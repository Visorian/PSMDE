<#
.SYNOPSIS
  Retrieves a single security recommendation by its ID or a list of all security recommendations affecting the organization.

.DESCRIPTION
  Retrieves a single security recommendation by its ID or a list of all security recommendations affecting the organization.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-all-recommendations?view=o365-worldwide

.PARAMETER id
  Optional. Specifies the id of the target MDE recommendation.

.EXAMPLE
  $recommendations = Get-MdeRecommendation

.EXAMPLE
  Get-MdeRecommendation -id '<GUID>'

.EXAMPLE
  Get-MdeRecommendation -filter "`$filter=vendor+eq+'microsoft'"

.ROLE
  @(@{permission = 'SecurityRecommendation.Read.All'; permissionType = 'Application'}, @{permission = 'SecurityRecommendation.Read'; permissionType = 'Delegated'})
#>

function Get-MdeRecommendation {
  [CmdletBinding(DefaultParameterSetName = 'id')]
  param (
    [Parameter(ParameterSetName = 'id', ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id,
    [Parameter(ParameterSetName = 'filter', ValueFromPipelineByPropertyName, ValueFromPipeline)]
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
    if ($id) {
      $uri = 'https://api.securitycenter.microsoft.com/api/recommendations/{0}' -f $id
      return Invoke-RetryRequest -Method Get -Uri $uri
    }
    $uri = 'https://api.securitycenter.microsoft.com/api/recommendations'
    if ($filter) {
      $uri += "?$filter"
    }
    return Invoke-AzureRequest -Uri $uri
  }
  End {}
}