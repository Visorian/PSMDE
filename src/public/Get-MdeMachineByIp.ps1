function Get-MdeMachineByIp {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ip,
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateScript({ $_ -gt ([DateTime]::now).AddDays(-30) })]
    [datetime]
    $timestamp = [DateTime]::Now
  )
  return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/machines/findbyip(ip='$ip',timestamp=$time)"
}
