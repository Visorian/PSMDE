function Get-MdeCveMachineReferences {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $cveId
  )
  return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/vulnerabilities/$cveId/machineReferences"
}