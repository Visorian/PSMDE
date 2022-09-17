<#
.SYNOPSIS
  Retrieves a collection of alerts related to a given user ID.

.DESCRIPTION
  Retrieves a collection of alerts related to a given user ID. The ID is not the full UPN, but only the user name. (for example, to retrieve alerts for user1@contoso.com use '-id user1').

.NOTES
  Author: Jan-Henrik Damaschke

.PARAMETER id
  Optional. Specifies the id of the target user.

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-user-related-alerts?view=o365-worldwide

.OUTPUTS
  PSCustomObject. The Get-MdeUserAlerts function returns a list of or a single PSCustomObject containing the parsed MDE machine object.

.EXAMPLE
  Get-MdeUserAlerts -id 'user1'

.ROLE
  @(@{permission = 'Alert.Read.All'; permissionType = 'Application'}, @{permission = 'Alert.ReadWrite.All'; permissionType = 'Application'}, @{permission = 'Alert.Read'; permissionType = 'Delegated'},  @{permission = 'Alert.ReadWrite'; permissionType = 'Delegated'})
#>

function Get-MdeUserAlerts {
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
    return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/users/$id/alerts"
  }
  End {}
}