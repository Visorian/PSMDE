<#
.SYNOPSIS
  Retrieves the organizational exposure score.

.DESCRIPTION
  Retrieves the organizational exposure score.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-machine-group-exposure-score?view=o365-worldwide

.OUTPUTS
  PSCustomObject. The Get-MdeExposureScore function returns a single PSCustomObject containing the parsed organizational exposure score object.

.EXAMPLE
  $score = Get-MdeExposureScore

.ROLE
  @(@{permission = 'Score.Read.All'; permissionType = 'Application'}, @{permission = 'Score.Read'; permissionType = 'Delegated'})
#>

function Get-MdeExposureScoreByMachineGroups {
  [CmdletBinding()]
  param ()
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
    $uri = 'https://api.securitycenter.microsoft.com/api/exposureScore/ByMachineGroups'
  }
  Process {
    return Invoke-AzureRequest -Uri $uri
  }
  End {}
}