function Get-MdeMachine {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id
  )
  if ($id) {
    return Invoke-RetryRequest -Method Get -Uri "https://api.securitycenter.microsoft.com/api/machines/$id"
  }
  return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/machines"
}