function Invoke-RetryRequest {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $method = 'get',
    [Parameter(Mandatory,
      ValueFromPipelineByPropertyName)]
    [string]
    $uri,
    [Parameter(ValueFromPipelineByPropertyName)]
    [object]
    $body
  )
  $sleepDuration = 0
  $retry = $false
  $headers = Get-MdeAuthorizationHeader
  do {
    try {
      $retry = $false
      if (@('put', 'patch', 'post') -contains $method.ToLower()) {
        return Invoke-RestMethod -Method $method -Headers $headers -Uri $uri -Body $body
      }
      else {
        return Invoke-RestMethod -Method $method -Headers $headers -Uri $uri
      }
    }
    catch {
      if ($error[0].Exception.Response.StatusCode.value__ -ne 429) { $retry = $false; Write-Error $error; break }
      $sleepDuration = $sleepDuration -eq 0 ? 4 : $sleepDuration * 2
      $retry = $true
      Write-Verbose "Retrying in $sleepDuration seconds"
      Start-Sleep -Seconds $sleepDuration
    } 
  } until (
    -not $retry
  )
}