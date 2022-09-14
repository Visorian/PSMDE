<#
.SYNOPSIS
  Gets one or multiple machine objects by OData filter

.DESCRIPTION
  Returns all Defender for Endpoint machines that matches the filter. For details, refer to the [OData docs article](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exposed-apis-odata-samples?view=o365-worldwide)

.NOTES
  Author: Jan-Henrik Damaschke

.EXAMPLE
  $machines = Get-MdeMachineByFilter -filter 'lastSeen gt 2018-08-01Z'

.EXAMPLE
  $machines = Get-MdeMachineByFilter -filter "startswith(computerDnsName,'mymachine')"

.EXAMPLE
  $machines = Get-MdeMachineByFilter -filter "healthStatus eq 'Active'"

.ROLE
  @(@{permission = 'Machine.Read.All'; permissionType = 'Application'}, @{permission = 'Machine.ReadWrite.All'; permissionType = 'Application'}, @{permission = 'Machine.Read'; permissionType = 'Delegated'}, @{permission = 'Machine.ReadWrite'; permissionType = 'Delegated'})
#>

function Get-MdeMachineByFilter {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $filter
  )
  Process {
    return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/machines?`$filter=$filter"
  }
}
