<#
.SYNOPSIS
  Retrieves a specific live response command result by its index.

.DESCRIPTION
  Retrieves a specific live response command result by its index.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-live-response-result?view=o365-worldwide

.PARAMETER id
  Specifies the id of the target live response machine action.

.PARAMETER index
  Optional. Specifies the index of the live response result (default: 0).

.EXAMPLE
  Get-MdeLiveResponseResult -id "<GUID>"

.EXAMPLE
  Get-MdeLiveResponseResult -id "<GUID>" -index 0

.ROLE
  @(@{permission = 'Machine.Read.All'; permissionType = 'Application'}, @{permission = 'Machine.ReadWrite.All'; permissionType = 'Application'}, @{permission = 'Machine.LiveResponse'; permissionType = 'Delegated'})
#>

function Get-MdeLiveResponseResult {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id,
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [int]
    $index = 0
  )
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
  }
  Process {
    return Invoke-RetryRequest -Method Get -Uri "https://api.securitycenter.microsoft.com/api/machineactions/$id/GetLiveResponseResultDownloadLink(index=$index)"
  }
  End {}
}
