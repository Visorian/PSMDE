<#
.SYNOPSIS
  A short one-line action-based description, e.g. 'Tests if a function is valid'

.DESCRIPTION
  A longer description of the function, its purpose, common use cases, etc.

.PARAMETER severity
  Specifies the severity, can be "Low", "Medium", "High" or "Critical".

.NOTES
  Information or caveats about the function e.g. 'This function is not supported in Linux'

.LINK
  Specify a URI to a help page, this will show when Get-Help -Online is used.

.EXAMPLE
  Test-MyTestFunction -Verbose
  Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines

.NOTES
  Author: Jan-Henrik Damaschke

.ROLE
  @(@{permission = 'Vulnerability.Read.All'; permissionType = 'Application'}, @{permission = 'Vulnerability.Read'; permissionType = 'Delegated'})
#>

function Get-MdeVulnerabilities {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateSet("Low", "Medium", "High", "Critical")]  
    [string]
    $severity
  )
  $uri = 'https://api.securitycenter.microsoft.com/api/vulnerabilities{0}' -f ([String]::IsNullOrEmpty($severity) ? '' : "?`$filter=severity+eq+'$severity'")
  return Invoke-AzureRequest -Uri $uri
}