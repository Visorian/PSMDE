<#
.SYNOPSIS
  Retrieves a list of all security baselines assessment profiles created by the organization.

.DESCRIPTION
  If no parameters are specified, returns all Defender for Endpoint baseline profiles.

.NOTES
  Author: Jan-Henrik Damaschke

.PARAMETER filter
  Optional. Specifies the filter for baseline profiles. A filter is supported for "id", "name", "operatingSystem", "operatingSystemVersion", "status", "settingsNumber", "passedDevices" and "totalDevices".

.OUTPUTS
  PSCustomObject. The Get-MdeBaselineProfile function returns a list of or a single PSCustomObject containing the parsed baseline profile objects.

.EXAMPLE
  $machines = Get-MdeBaselineProfile

.ROLE
  @(@{permission = 'SecurityConfiguration.Read.All'; permissionType = 'Application'}, @{permission = 'SecurityBaselinesAssessment.Read.All'; permissionType = 'Application'}, @{permission = 'SecurityBaselinesAssessment.Read'; permissionType = 'Delegated'}, @{permission = 'SecurityConfiguration.Read'; permissionType = 'Delegated'})
#>

function Get-MdeBaselineProfile {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $filter
  )
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
  }
  Process {
    $uri = 'https://api.securitycenter.microsoft.com/api/baselineProfiles'
    if ($filter) {
      $uri += "?$filter" -f $id
    }
    return Invoke-AzureRequest -Uri $uri
  }
  End {}
}