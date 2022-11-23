<#
.SYNOPSIS
  Undo isolation of a device.

.DESCRIPTION
  Undo isolation of a device.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/unisolate-machine?view=o365-worldwide

.PARAMETER id
  Specifies the id of the target MDE machine.

.PARAMETER comment
  Comment to associate with the action.

.EXAMPLE
  Disable-MdeMachineIsolation -id "<GUID>"

.EXAMPLE
  Disable-MdeMachineIsolation -id "<GUID>" -comment "Your comment"

.ROLE
  @(@{permission = 'Machine.Isolate'; permissionType = 'Application'}, @{permission = 'Machine.Isolate'; permissionType = 'Delegated'})
#>

function Disable-MdeMachineIsolation {
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
    return Invoke-RetryRequest -Method Post -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/unisolate" -body (ConvertTo-Json -InputObject @{ Comment = $comment })
  }
  End {}
}

