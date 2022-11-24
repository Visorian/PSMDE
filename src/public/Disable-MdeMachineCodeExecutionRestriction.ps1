<#
.SYNOPSIS
  Restrict execution of all applications on the device except a predefined set.

.DESCRIPTION
  Restrict execution of all applications on the device except a predefined set.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/restrict-code-execution?view=o365-worldwide

.PARAMETER id
  Optional. Specifies the id of the target MDE recommendation.

.EXAMPLE
  Disable-MdeMachineCodeExecutionRestriction -id "<GUID>" -comment "Your comment"

.ROLE
  @(@{permission = 'Machine.RestrictExecution'; permissionType = 'Application'}, @{permission = 'Machine.RestrictExecution'; permissionType = 'Delegated'})
#>

function Disable-MdeMachineCodeExecutionRestriction {
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
    return Invoke-RetryRequest -Method Post -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/unrestrictCodeExecution" -body (ConvertTo-Json -InputObject @{ Comment = $comment })
  }
  End {}
}