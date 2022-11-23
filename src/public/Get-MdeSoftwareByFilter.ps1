<#
.SYNOPSIS
  Retrieves the organization software inventory by OData filter.

.DESCRIPTION
  Retrieves the organization software inventory by OData filter.

.NOTES
  Author: Jan-Henrik Damaschke

.PARAMETER filter
  Specifies the OData filter for MDE software.

.OUTPUTS
  PSCustomObject. The Get-MdeSoftwareByFilter function returns a list of or a single PSCustomObject containing the parsed MDE software object.

.LINK
  https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exposed-apis-odata-samples?view=o365-worldwide

.EXAMPLE
  $software = Get-MdeSoftwareByFilter -filter "vendor ne 'microsoft'"

.EXAMPLE
  $software = Get-MdeSoftwareByFilter -filter "id+eq+'microsoft-_-edge'&`$top=10"

.ROLE
  @(@{permission = 'Software.Read.All'; permissionType = 'Application'}, @{permission = 'Software.Read'; permissionType = 'Delegated'})
#>

function Get-MdeSoftwareByFilter {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
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
    return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/Software?`$filter=$filter"
  }
  End {}
}