function Get-MdeMachineAlerts {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory,
      ValueFromPipelineByPropertyName)]
    [string]
    $id
  )
  return Invoke-AzureRequest -Method Get -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/alerts"
}