function Get-MdeAuthorizationInfo {
  [CmdletBinding()]
  param ()
  if ($script:tokenCache) {
    $tc = Get-AesSessionSecret -cipherText $script:tokenCache
    $parsedToken = Get-ParsedToken -token $tc
    $expired = [DateTime]::Now -gt [TimeZoneInfo]::ConvertTimeFromUtc(([DateTime]::UnixEpoch).AddSeconds($parsedToken.exp), [TimeZoneInfo]::FindSystemTimeZoneById('Central European Standard Time'))
    $resultObject = @{
      tokenExpired = $expired
      scopes       = (Get-ParsedToken -token $tc).roles
    }
    Out-VerboseHashTable -hashtable $resultObject
    return $resultObject
  }
  Write-Verbose "No session token"
  return $null
}