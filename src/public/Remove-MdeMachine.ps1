<#
.SYNOPSIS
  Offboard device from Defender for Endpoint.

.DESCRIPTION
  Offboard device from Defender for Endpoint.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/offboard-machine-api?view=o365-worldwide

.PARAMETER id
  Specifies the id of the target MDE machine.

.PARAMETER comment
  Comment to associate with the action.

.EXAMPLE
  Remove-MdeMachine -id "MACHINE_ID" -comment "Your comment"

.ROLE
  @(@{permission = 'Machine.Offboard'; permissionType = 'Application'}, @{permission = 'Machine.Offboard'; permissionType = 'Delegated'})
#>

function Remove-MdeMachine {
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
    return Invoke-RetryRequest -Method Post -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/offboard" -body (ConvertTo-Json -InputObject @{ Comment = $comment })
  }
  End {}
}