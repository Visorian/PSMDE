<#
.SYNOPSIS
  Get a URI that allows downloading of an Investigation package.

.DESCRIPTION
  Get a URI that allows downloading of an Investigation package.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-package-sas-uri?view=o365-worldwide

.PARAMETER id
  Specifies the id of a machine action with the type CollectInvestigationPackage.

.EXAMPLE
  $result = Get-MdeMachineInvestigationPackageUri

.EXAMPLE
  Get-MdeMachineInvestigationPackageUri -id "MACHINE_ACTION_ID"

.ROLE
  @(@{permission = 'Machine.Read.All'; permissionType = 'Application'}, @{permission = 'Machine.ReadWrite.All'; permissionType = 'Application'}, @{permission = 'Machine.CollectForensics'; permissionType = 'Delegated'})
#>

function Get-MdeMachineInvestigationPackageUri {
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
    return Invoke-RetryRequest -Method Get -Uri "https://api.securitycenter.microsoft.com/api/machineactions/$id/GetPackageUri"
  }
  End {}
}
