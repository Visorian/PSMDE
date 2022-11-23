<#
.SYNOPSIS
  Collect investigation package from a device.

.DESCRIPTION
  Collect investigation package from a device.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/...

.PARAMETER id
  Optional. Specifies the id of the target MDE recommendation.

.EXAMPLE
  $result = Get-MdeMachineInvestigationPackage

.EXAMPLE
  Get-MdeMachineInvestigationPackage -id "<GUID>"

.EXAMPLE
  Get-MdeMachineInvestigationPackage -filter "$filter=vendor+eq+'microsoft'"

.ROLE
  @(@{permission = ''; permissionType = 'Application'}, @{permission = ''; permissionType = 'Delegated'})
#>

function Get-MdeMachineInvestigationPackage {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id
  )
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
  }
  Process {
    return Invoke-AzureRequest -Method Get -Uri "https://api.securitycenter.microsoft.com/api/"
  }
  End {}
}
