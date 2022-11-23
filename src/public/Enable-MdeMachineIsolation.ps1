<#
.SYNOPSIS
  Isolates a device from accessing external network.

.DESCRIPTION
  Isolates a device from accessing external network.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/isolate-machine?view=o365-worldwide

.PARAMETER id
  Specifies the id of the target MDE machine.

.PARAMETER comment
  Comment to associate with the action.

.PARAMETER isolationType
  Optional. Type of the isolation. Allowed values are: 'Full' or 'Selective' (default: 'Full').

.EXAMPLE
  Enable-MdeMachineIsolation -id "<GUID>"

.EXAMPLE
  Enable-MdeMachineIsolation -id "<GUID>" -comment "Your comment"

.ROLE
  @(@{permission = 'Machine.Isolate'; permissionType = 'Application'}, @{permission = 'Machine.Isolate'; permissionType = 'Delegated'})
#>

function Enable-MdeMachineIsolation {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id,
    [Parameter(Mandatory)]
    [string]
    $comment,
    [Parameter()]
    [ValidateSet('Full', 'Selective')]
    [string]
    $isolationType = 'Full'
  )
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
  }
  Process {
    return Invoke-RetryRequest -Method Post -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/isolate" -body (ConvertTo-Json -InputObject @{ Comment = $comment; IsolationType = $isolationType })
  }
  End {}
}
