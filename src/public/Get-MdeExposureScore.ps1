<#
.SYNOPSIS
  Retrieves the organizational exposure score.

.DESCRIPTION
  Retrieves the organizational exposure score.

.NOTES
  Author: Jan-Henrik Damaschke

.OUTPUTS
  PSCustomObject. The Get-MdeExposureScore function returns a single PSCustomObject containing the parsed organizational exposure score object.

.EXAMPLE
  $score = Get-MdeExposureScore

.ROLE
  @(@{permission = 'Score.Read.All'; permissionType = 'Application'}, @{permission = 'Score.Read'; permissionType = 'Delegated'})
#>

function Get-MdeExposureScore {
  [CmdletBinding()]
  param ()
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
    $uri = 'https://api.securitycenter.microsoft.com/api/exposureScore'
  }
  Process {
    return Invoke-RetryRequest -Uri $uri -Method Get
  }
  End {}
}