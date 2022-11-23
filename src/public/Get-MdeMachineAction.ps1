<#
.SYNOPSIS
  Retrieves a collection of or a specific Machine Action by its ID.

.DESCRIPTION
  Retrieves a collection of or a specific Machine Action by its ID.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-machineaction-object?view=o365-worldwide

.PARAMETER id
  Optional. Specifies the id of the target MDE machine action.

.PARAMETER filter
  Optional. Specifies the filter for baseline configurations. A filter is supported for  "id", "status", "machineId", "type", "requestor", and "creationDateTimeUtc".

.EXAMPLE
  $result = Get-MdeMachineAction

.EXAMPLE
  Get-MdeMachineAction -id "<GUID>"

.EXAMPLE
  Get-MdeMachineAction -filter "$filter=vendor+eq+'microsoft'"

.ROLE
  @(@{permission = 'Machine.Read.All'; permissionType = 'Application'}, @{permission = 'Machine.ReadWrite.All'; permissionType = 'Application'}, @{permission = 'Machine.Read'; permissionType = 'Delegated'}, @{permission = 'Machine.ReadWrite'; permissionType = 'Delegated'})
#>

function Get-MdeMachineAction {
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
      return Invoke-RetryRequest -Method Get -Uri "https://api.securitycenter.microsoft.com/api/machineactions/$id"
    }
    $uri = 'https://api.securitycenter.microsoft.com/api/machineactions'
    if ($filter) {
      $uri += "?$filter"
    }
    return Invoke-AzureRequest -Uri $uri
  }
  End {}
}
