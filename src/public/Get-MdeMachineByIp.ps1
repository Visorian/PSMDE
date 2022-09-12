function Get-MdeMachineByIp {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, 
      ValueFromPipelineByPropertyName)]
    [string]
    $ip,
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScript({ $_ -gt ([DateTime]::now).AddDays(-30) })]
    [datetime]
    $timestamp = [DateTime]::Now
  )
  return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/machines/findbyip(ip='$ip',timestamp=$time)"
}
