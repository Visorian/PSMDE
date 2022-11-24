<#
.SYNOPSIS
  Runs a sequence of live response commands on a device.

.DESCRIPTION
  Runs a sequence of live response commands on a device.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/run-live-response?view=o365-worldwide

.PARAMETER id
  Specifies the id of the target MDE machine.

.PARAMETER comment
  Comment to associate with the action.

.PARAMETER commands
  Array of commands to run. Allowed values are "PutFile", "RunScript", "GetFile". See the reference link for more details on the body.

.EXAMPLE
  Invoke-MdeMachineLiveResponse -id "MACHINE_ID" -comment "Your comment" -commands @(@{type = "RunScript"; params = @(@{key = "scriptName"; value = "scriptFile.ps1"}; @{key = "Args"; value = "argument1"})})

.ROLE
  @(@{permission = 'Machine.LiveResponse'; permissionType = 'Application'}, @{permission = 'Machine.LiveResponse'; permissionType = 'Delegated'})
#>

function Invoke-MdeMachineLiveResponse {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id,
    [Parameter(Mandatory)]
    [string]
    $comment,
    [Parameter(Mandatory)]
    [array]
    $commands
  )
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
  }
  Process {
    return Invoke-RetryRequest -Method Post -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/runliveresponse" -body (ConvertTo-Json -Depth 5 -InputObject @{ Comment = $comment; Commands = $commands })
  }
  End {}
}

