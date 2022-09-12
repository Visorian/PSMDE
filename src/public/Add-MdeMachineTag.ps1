function Add-MdeMachineTag {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id,
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $tag
  )
  $body = @{
    Value  = $tag
    Action = 'Add'
  }
  return Invoke-RetryRequest -Method Post -body (ConvertTo-Json -InputObject $body) -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/tags"
}