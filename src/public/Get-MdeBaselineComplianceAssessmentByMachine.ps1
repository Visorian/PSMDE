<#
.SYNOPSIS
  Returns all security baselines assessments for all devices, on a per-device basis.

.DESCRIPTION
  Returns all security baselines assessments for all devices, on a per-device basis. It returns a table with a separate entry for every unique combination of DeviceId, ProfileId, ConfigurationId.

.NOTES
  Author: Jan-Henrik Damaschke

.OUTPUTS
  PSCustomObject. The Get-MdeBaselineComplianceAssessmentByMachine function returns a list of or a single PSCustomObject containing the parsed baseline compliance assessment objects.

.EXAMPLE
  $machines = Get-MdeBaselineComplianceAssessmentByMachine

.ROLE
  @(@{permission = 'SecurityBaselinesAssessment.Read.All'; permissionType = 'Application'}, @{permission = 'SecurityBaselinesAssessment.Read'; permissionType = 'Delegated'})
#>

function Get-MdeBaselineComplianceAssessmentByMachine {
  [CmdletBinding()]
  param ()
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
    $uri = 'https://api.securitycenter.microsoft.com/api/machines/baselineComplianceAssessmentByMachine'
  }
  Process {
    return Invoke-AzureRequest -Uri $uri
  }
  End {}
}