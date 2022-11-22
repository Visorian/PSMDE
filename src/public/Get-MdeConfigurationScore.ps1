<#
.SYNOPSIS
  Retrieves your Microsoft Secure Score for Devices.

.DESCRIPTION
  Retrieves your Microsoft Secure Score for Devices. A higher Microsoft Secure Score for Devices means your endpoints are more resilient from cybersecurity threat attacks.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-device-secure-score?view=o365-worldwide

.OUTPUTS
  PSCustomObject. The Get-MdeConfigurationScore function returns a single PSCustomObject containing the parsed device secure score object.

.EXAMPLE
  $score = Get-MdeConfigurationScore

.ROLE
  @(@{permission = 'Score.Read.All'; permissionType = 'Application'}, @{permission = 'Score.Read'; permissionType = 'Delegated'})
#>

function Get-MdeConfigurationScore {
  [CmdletBinding()]
  param ()
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
    $uri = 'https://api.securitycenter.microsoft.com/api/configurationScore'
  }
  Process {
    return Invoke-RetryRequest -Uri $uri -Method Get
  }
  End {}
}