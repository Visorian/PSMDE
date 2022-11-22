<#
.SYNOPSIS
  Returns one or more links to all security baselines assessments for all devices, on a per-device basis.

.DESCRIPTION
  Returns one or more links to all security baselines assessments for all devices, on a per-device basis. It returns a table with a separate entry for every unique combination of DeviceId, ProfileId, ConfigurationId.

.PARAMETER sasValidHours
  Optional. The number of hours that the download URLs will be valid for (Maximum 24 hours).

.NOTES
  Author: Jan-Henrik Damaschke

.OUTPUTS
  PSCustomObject. The Get-MdeBaselineComplianceAssessmentExport function returns a list of or a single PSCustomObject containing the parsed baseline compliance assessment objects.

.EXAMPLE
  $machines = Get-MdeBaselineComplianceAssessmentExport

.EXAMPLE
  $machines = Get-MdeBaselineComplianceAssessmentExport -sasValidHours 12

.ROLE
  @(@{permission = 'SecurityBaselinesAssessment.Read.All'; permissionType = 'Application'}, @{permission = 'SecurityBaselinesAssessment.Read'; permissionType = 'Delegated'})
#>

function Get-MdeBaselineComplianceAssessmentExport {
  [CmdletBinding()]
  param (
    [Parameter()]
    [Int]
    [ValidateRange(1,24)]
    $sasValidHours
  )
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
    $uri = 'https://api.securitycenter.microsoft.com/api/machines/BaselineComplianceAssessmentExport{0}' -f ($sasValidHours ? "?sasValidHours=$sasValidHours" : '')
  }
  Process {
    return Invoke-RetryRequest -Uri $uri -Method Get
  }
  End {}
}