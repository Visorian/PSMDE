function Get-MdeMachineCves {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory,
      ValueFromPipelineByPropertyName)]
    [ValidateSet("Low", "Medium", "High", "Critical")]  
    [string]
    $severity
  )
  $uri = 'https://api.securitycenter.microsoft.com/api/vulnerabilities/machinesVulnerabilities{0}' -f ([String]::IsNullOrEmpty($severity) ? '' : "?`$filter=severity+eq+'$severity'")
  return Invoke-AzureRequest -Uri $uri
}