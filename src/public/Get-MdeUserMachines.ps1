<#
.SYNOPSIS
  Retrieves a collection of devices related to a given user ID.

.DESCRIPTION
  Retrieves a collection of devices related to a given user ID. The ID is not the full UPN, but only the user name. (for example, to retrieve alerts for user1@contoso.com use '-id user1').

.NOTES
  Author: Jan-Henrik Damaschke

.PARAMETER id
  Optional. Specifies the id of the target user.

.OUTPUTS
  PSCustomObject. The Get-MdeUserMachines function returns a list of or a single PSCustomObject containing the parsed MDE machine object.

.EXAMPLE
  Get-MdeUserMachines -id 'user1'

.ROLE
  @(@{permission = 'Machine.Read.All'; permissionType = 'Application'}, @{permission = 'Machine.ReadWrite.All'; permissionType = 'Application'}, @{permission = 'Machine.Read'; permissionType = 'Delegated'}, @{permission = 'Machine.ReadWrite'; permissionType = 'Delegated'})
#>

function Get-MdeUserMachines {
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
    return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/users/$id/machines"
  }
  End {}
}