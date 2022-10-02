function Get-MdeAuthorizationHeader {
  $tc = $script:tokenCache ? (Get-AesSessionSecret -cipherText $script:tokenCache) : $null

  $expired = $tc ? [DateTime]::Now -gt [TimeZoneInfo]::ConvertTimeFromUtc(
		([DateTime]::UnixEpoch).AddSeconds(
			(Get-ParsedToken -token $tc).exp), [TimeZoneInfo]::FindSystemTimeZoneById('Central European Standard Time')
  ) : $true

  Write-Verbose "Token expired: $expired"

  # If the token hasn't expired, return the expired token.
  if (-not($expired)) {
    return @{ Authorization = "Bearer $tc" }
  }

  # If the appID, appSecret and tenentID is missing, throw an error.
  if (-not($script:appId -and $script:appSecret -and $script:tenantId)) {
    Throw 'Authorization info missing. If you provided the token directly, you have to update it manually using Set-MdeAuthorizationInfo.'
  }

  try {
    $ai = Get-AesSessionSecret -cipherText $script:appId
    $as = Get-AesSessionSecret -cipherText $script:appSecret
    $ti = Get-AesSessionSecret -cipherText $script:tenantId

    Write-Verbose "Acquiring new access token"

    $resourceAppIdUri = 'https://api.securitycenter.microsoft.com'
    $oAuthUri = "https://login.microsoftonline.com/$ti/oauth2/token"

    $authBody = [Ordered] @{
      resource      = "$resourceAppIdUri"
      client_id     = "$ai"
      client_secret = "$as"
      grant_type    = 'client_credentials'
    }

    # Invoke the Rest Request
    $params = @{
      Method      = 'POST'
      URI         = $oAuthUri
      Body        = $authBody
      ErrorAction = 'Stop'
    }

    $authResponse = Invoke-RestMethod @params

    $tc = $authResponse.access_token
    $script:tokenCache = New-AesSessionSecret -secret $tc
  }
  catch {
    Throw ("Failed to acquire token. Details below: {0}" -f (Get-Error -Newest 1).ToString())
  }

  return @{ Authorization = "Bearer $tc" }
}
