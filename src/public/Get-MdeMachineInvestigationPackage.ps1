<#
.SYNOPSIS
  Collect investigation package from a device.

.DESCRIPTION
  Collect investigation package from a device.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/collect-investigation-package?view=o365-worldwide

.PARAMETER id
  Specifies the id of the target machine for the investigation package.

.PARAMETER comment
  Comment to associate with the action.

.EXAMPLE
  $result = Get-MdeMachineInvestigationPackage

.EXAMPLE
  Get-MdeMachineInvestigationPackage -id "MACHINE_ID"

.ROLE
  @(@{permission = 'Machine.CollectForensics'; permissionType = 'Application'}, @{permission = 'Machine.CollectForensics'; permissionType = 'Delegated'})
#>

function Get-MdeMachineInvestigationPackage {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id,
    [Parameter(Mandatory)]
    [string]
    $comment
  )
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
  }
  Process {
    return Invoke-RetryRequest -Method Post -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/collectInvestigationPackage" -body (ConvertTo-Json -InputObject @{Comment = $comment })
  }
  End {}
}
