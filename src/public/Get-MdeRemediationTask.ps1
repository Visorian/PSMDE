<#
.SYNOPSIS
  Returns information about all or one specified remediation activity.

.DESCRIPTION
  Returns information about all or one specified remediation activity. Presents the same columns as Get all remediation activity", but returns results only for the one specified remediation activity.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-remediation-one-activity?view=o365-worldwide

.EXAMPLE
  $exposures = Get-MdeRemediationTask

.EXAMPLE
  Get-MdeRemediationTask -id '<GUID>'

.ROLE
  @(@{permission = 'RemediationTasks.Read.All'; permissionType = 'Application'}, @{permission = 'RemediationTask.Read.Read'; permissionType = 'Delegated'})
#>

function Get-MdeRemediationTask {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
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
    if ($id) {
      $uri = 'https://api.securitycenter.microsoft.com/api/remediationtasks/{0}' -f $id
      return Invoke-RetryRequest -Method Get -Uri $uri
    }
    $uri = 'https://api.securitycenter.microsoft.com/api/remediationtasks'
    return Invoke-AzureRequest -Uri $uri
  }
  End {}
}