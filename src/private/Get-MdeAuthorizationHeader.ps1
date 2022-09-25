function Get-MdeAuthorizationHeader {

	if ($script:tokenCache) { 
		$tc = Get-AesSessionSecret -cipherText $script:tokenCache
	} else {
		$tc = $null 
	}

	$expired = $tc ? [DateTime]::Now -gt [TimeZoneInfo]::ConvertTimeFromUtc(
		([DateTime]::UnixEpoch).AddSeconds(
			(Get-ParsedToken -token $tc).exp), [TimeZoneInfo]::FindSystemTimeZoneById('Central European Standard Time')
	) : $true

	Write-Verbose "Token expired: $expired"

	# If the token hasen't expired, return the expired token.
	if (-not($expired)) {
		return @{ Authorization = "Bearer $tc" }
	}

	# If the appID, appSecret and tenentID is missing, throw an error.
	if (-not($script:appId -and $script:appSecret -and $script:tenantId)) {

		Throw 'Authorization info missing. If you provided the token directly, you have to update it manually using Set-MdeAuthorizationInfo.'
		return

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
		$authResponse = Invoke-RestMethod -Method Post -Uri $oAuthUri -Body $authBody -ErrorAction Stop

		$tc = $authResponse.access_token
		$script:tokenCache = New-AesSessionSecret -secret $tc

	} catch {

		Throw ("Failed to acquire token. Details below: {0}" -f (Get-Error -Newest 1).ToString())
		return
		
	}

	return @{ Authorization = "Bearer $tc" }

}
