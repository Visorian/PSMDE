function Update-MdeMachine {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id,
    [Parameter(ValueFromPipelineByPropertyName)]
    [array]
    $tags,
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateSet('Low', 'Normal', 'High')]
    [string]
    $priority
  )
  $body = @{}
  if ($tags) { $body.machineTags = $tags }
  if ($priority) { $body.deviceValue = $priority }
  if ($body.Keys.Count) {
    $null = Invoke-RetryRequest -Method Patch -body (ConvertTo-Json -InputObject $body) -Uri "https://api.securitycenter.microsoft.com/api/machines/$id"
    Write-Verbose "Updated $id with $($body.Keys)"
  }
}