<#
.SYNOPSIS
  Retrieves a list of your organization's software version distribution.

.DESCRIPTION
  Retrieves a list of your organization's software version distribution.

.NOTES
  Author: Jan-Henrik Damaschke

.PARAMETER id
  Optional. Specifies the id of the target software.

.OUTPUTS
  PSCustomObject. The Get-MdeSoftwareDistribution function returns a list of or a single PSCustomObject containing the parsed MDE software object.

.EXAMPLE
  Get-MdeSoftwareDistribution -id 'microsoft-_-edge'

.ROLE
  @(@{permission = 'Software.Read.All'; permissionType = 'Application'}, @{permission = 'Software.Read'; permissionType = 'Delegated'})
#>

function Get-MdeSoftwareDistribution {
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
    return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/Software/$id/distributions"
  }
  End {}
}