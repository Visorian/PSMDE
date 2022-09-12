function Get-MdeMachineSoftware {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id
  )
  return Invoke-AzureRequest -Method Get -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/software"
}