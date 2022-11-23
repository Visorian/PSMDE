<#
.SYNOPSIS
  Retrieves a list of all the possible security baselines assessment configurations and settings for all the available benchmarks.

.DESCRIPTION
  If no parameters are specified, returns all Defender for Endpoint baseline configurations.

.NOTES
  Author: Jan-Henrik Damaschke

.PARAMETER filter
  Optional. Specifies the OData filter for baseline configurations. A filter is supported for "id", "name", "operatingSystem", "operatingSystemVersion", "status", "settingsNumber", "passedDevices" and "totalDevices".

.OUTPUTS
  PSCustomObject. The Get-MdeBaselineConfiguration function returns a list of or a single PSCustomObject containing the parsed baseline configuration objects.

.EXAMPLE
  $machines = Get-MdeBaselineConfiguration

.EXAMPLE
  $machines = Get-MdeBaselineConfiguration -filter "id+eq+'123'"

.ROLE
  @(@{permission = 'SecurityConfiguration.Read.All'; permissionType = 'Application'}, @{permission = 'SecurityBaselinesAssessment.Read.All'; permissionType = 'Application'}, @{permission = 'SecurityBaselinesAssessment.Read'; permissionType = 'Delegated'}, @{permission = 'SecurityConfiguration.Read'; permissionType = 'Delegated'})
#>

function Get-MdeBaselineConfiguration {
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
    $uri = 'https://api.securitycenter.microsoft.com/api/baselineConfigurations'
    if ($filter) {
      $uri += "?`$filter=$filter"
    }
    return Invoke-AzureRequest -Uri $uri
  }
  End {}
}