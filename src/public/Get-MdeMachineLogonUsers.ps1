<#
.SYNOPSIS
  Retrieves a collection of logged on users on a specific device.

.DESCRIPTION
  Retrieves a collection of logged on users on a specific device.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-machine-log-on-users?view=o365-worldwide

.EXAMPLE
  Get-MdeMachineLogonUsers -id '123'

.ROLE
  @(@{permission = 'User.Read.All'; permissionType = 'Application'}, @{permission = 'User.Read.All'; permissionType = 'Delegated'})
#>
function Get-MdeMachineLogonUsers {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id
  )
  return Invoke-AzureRequest -Method Get -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/logonusers"
}