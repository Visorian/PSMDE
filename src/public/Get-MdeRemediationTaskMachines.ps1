<#
.SYNOPSIS
  Returns information about exposed devices for the specified remediation task.

.DESCRIPTION
  Returns information about exposed devices for the specified remediation task.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-remediation-exposed-devices-activities?view=o365-worldwide

.EXAMPLE
  $exposures = Get-MdeRemediationTaskMachines

.EXAMPLE
  Get-MdeRemediationTaskMachines -id '<GUID>'

.ROLE
  @(@{permission = 'RemediationTasks.Read.All'; permissionType = 'Application'}, @{permission = 'RemediationTask.Read.Read'; permissionType = 'Delegated'})
#>

function Get-MdeRemediationTaskMachines {
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
    $uri = 'https://api.securitycenter.microsoft.com/api/remediationtasks/{0}/machinereferences' -f $id
    return Invoke-AzureRequest -Uri $uri
  }
  End {}
}