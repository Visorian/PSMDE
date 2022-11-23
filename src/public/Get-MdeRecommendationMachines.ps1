<#
.SYNOPSIS
  Retrieves a list of devices associated with the security recommendation.

.DESCRIPTION
  Retrieves a list of devices associated with the security recommendation.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/list-recommendation-software?view=o365-worldwide

.PARAMETER id
  Optional. Specifies the id of the target MDE recommendation.

.EXAMPLE
  Get-MdeRecommendationMachines -id 'va-_-google-_-chrome'

.ROLE
  @(@{permission = 'SecurityRecommendation.Read.All'; permissionType = 'Application'}, @{permission = 'SecurityRecommendation.Read'; permissionType = 'Delegated'})
#>

function Get-MdeRecommendationMachines {
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
    $uri = 'https://api.securitycenter.microsoft.com/api/recommendations/{0}/machineReferences' -f $id
    return Invoke-AzureRequest -Uri $uri
  }
  End {}
}