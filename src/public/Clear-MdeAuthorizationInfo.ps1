<#
.SYNOPSIS
  Clears the authorization information that is used to get a valid MDE token.

.DESCRIPTION
  Clears the authorization information that is used to get a valid MDE token.

.NOTES
  Author: Jan-Henrik Damaschke

.EXAMPLE
  Clear-MdeAuthorizationInfo
#>

function Clear-MdeAuthorizationInfo {
  [CmdletBinding()]
  param ()
  $script:tenantId = $null
  $script:appId = $null
  $script:appSecret = $null
  $script:tokenCache = $null
  Write-Verbose "Authorization info cleared"
}
