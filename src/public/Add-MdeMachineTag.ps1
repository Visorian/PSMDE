function Add-MdeMachineTag {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory,
      ValueFromPipelineByPropertyName)]
    [string]
    $id,
    [Parameter(Mandatory,
      ValueFromPipelineByPropertyName)]
    [string]
    $tag
  )
  $body = @{
    Value  = $tag
    Action = 'Add'
  }
  return Invoke-RetryRequest -Method Post -body (ConvertTo-Json -InputObject $body) -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/tags"
}