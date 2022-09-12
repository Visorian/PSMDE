function Get-MdeAuthorizationHeader {
  if ($script:tokenCache) { $tc = Get-AesSessionSecret -cipherText $script:tokenCache } else { $tc = $null }
  $expired = $tc ? [DateTime]::Now -gt [TimeZoneInfo]::ConvertTimeFromUtc(([DateTime]::UnixEpoch).AddSeconds((Get-ParsedToken -token $tc).exp), [TimeZoneInfo]::FindSystemTimeZoneById('Central European Standard Time')) : $true
  Write-Verbose "Token expired: $expired"
  if ($expired) {
    if ($appId -and $appSecret -and $tenantId) {
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
        $authResponse = Invoke-RestMethod -Method Post -Uri $oAuthUri -Body $authBody -ErrorAction Stop
        $tc = $authResponse.access_token
        $script:tokenCache = New-AesSessionSecret -secret $tc
      }
      catch {
        Write-Error "Failed to acquire token"
      }
    }
    else {
      Write-Error 'Authorization info missing, have you executed Set-MdeAuthorizationInfo?'
      break
    }
  }
  return @{ Authorization = "Bearer $tc" }
}