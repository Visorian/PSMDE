function Invoke-AzureRequest {
  [CmdletBinding()]
  param (
    [string]
    $uri
  )
  $reply = Invoke-RetryRequest -Method Get -Uri $uri
  $content = $reply.value
  while (-not [String]::IsNullOrEmpty($reply.'@odata.nextLink')) {
    Write-Verbose "Found next link: $($reply.'@odata.nextLink')"
    $reply = Invoke-RetryRequest -Method Get -Uri $reply.'@odata.nextLink'
    foreach ($value in $reply.value) {
      $content += $value
    }
  }
  return $content
}
