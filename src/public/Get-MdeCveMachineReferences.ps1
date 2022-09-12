function Get-MdeCveMachineReferences {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory,
      ValueFromPipelineByPropertyName)]
    [string]
    $cveId
  )
  return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/vulnerabilities/$cveId/machineReferences"
}