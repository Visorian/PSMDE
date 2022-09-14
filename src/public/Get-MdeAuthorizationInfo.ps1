<#
.SYNOPSIS
  Returns the authorization information that is used to get a valid MDE token.

.DESCRIPTION
  Returns the authorization information that is used to get a valid MDE token including current token expiration state and current token roles. To clear, please use the Clear-MdeAuthorizationInfo function.

.NOTES
  Author: Jan-Henrik Damaschke

.EXAMPLE
  Get-MdeAuthorizationInfo
#>

function Get-MdeAuthorizationInfo {
  [CmdletBinding()]
  param ()
  if ($script:tokenCache) {
    $tc = Get-AesSessionSecret -cipherText $script:tokenCache
    $parsedToken = Get-ParsedToken -token $tc
    $expired = [DateTime]::Now -gt [TimeZoneInfo]::ConvertTimeFromUtc(([DateTime]::UnixEpoch).AddSeconds($parsedToken.exp), [TimeZoneInfo]::FindSystemTimeZoneById('Central European Standard Time'))
    $resultObject = @{
      tokenExpired = $expired
      roles       = (Get-ParsedToken -token $tc).roles
    }
    Out-VerboseHashTable -hashtable $resultObject
    return $resultObject
  }
  Write-Verbose "No session token"
  return $null
}