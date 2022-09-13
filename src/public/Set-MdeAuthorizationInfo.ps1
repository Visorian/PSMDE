<#
.SYNOPSIS
  Set the authorization information that is used to get a valid MDE token.

.DESCRIPTION
  Set the authorization information that is used to get a valid MDE token.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exposed-apis-create-app-webapp?view=o365-worldwide

.EXAMPLE
  Set-MdeAuthorizationInfo -tenantId '00000000-0000-0000-0000-000000000000' -appId '00000000-0000-0000-0000-000000000000' -appSecret 'APP_SECRET'
#>

function Set-MdeAuthorizationInfo {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $tenantId,
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $appId,
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $appSecret,
    [switch]
    $noTokenRefresh
  )
  $script:tenantId = New-AesSessionSecret -secret $tenantId
  $script:appId = New-AesSessionSecret -secret $appId
  $script:appSecret = New-AesSessionSecret -secret $appSecret

  Write-Verbose "Refreshing access token"
  if (-not $noTokenRefresh) { $null = Get-MdeAuthorizationHeader }
}