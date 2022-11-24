<#
.SYNOPSIS
  Cancel an already launched machine action.

.DESCRIPTION
  Cancel an already launched machine action that is not yet in final state (completed, canceled, failed). The necessary API permission (scope) depends on the type of machine action to be stopped.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/...

.PARAMETER id
  Specifies the id of the target MDE machine action.

.PARAMETER comment
  Comment to associate with the cancellation action.

.EXAMPLE
  Remove-MdeMachine -id "MACHINE_ACTION_ID" -comment "Your comment"

.ROLE
  @(@{permission = 'Machine.CollectForensics'; permissionType = 'Application' }, @{permission = 'Machine.Isolate'; permissionType = 'Application' }, @{permission = 'Machine.RestrictExecution'; permissionType = 'Application' }, @{permission = 'Machine.Scan'; permissionType = 'Application' }, @{permission = 'Machine.Offboard'; permissionType = 'Application' }, @{permission = 'Machine.StopAndQuarantine'; permissionType = 'Application' }, @{permission = 'Machine.LiveResponse'; permissionType = 'Application' }, @{permission = 'Machine.CollectForensics'; permissionType = 'Delegated' },@{permission = 'Machine.Isolate'; permissionType = 'Delegated' },@{permission = 'Machine.RestrictExecution'; permissionType = 'Delegated' },@{permission = 'Machine.Scan'; permissionType = 'Delegated' },@{permission = 'Machine.Offboard'; permissionType = 'Delegated' },@{permission = 'Machine.StopAndQuarantineMachine.LiveResponse'; permissionType = 'Delegated' })
#>

function Stop-MdeMachineAction {
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
    return Invoke-RetryRequest -Method Post -Uri "https://api.securitycenter.microsoft.com/api/machineactions/$id/cancel" -body (ConvertTo-Json -InputObject @{ Comment = $comment })
  }
  End {}
}
