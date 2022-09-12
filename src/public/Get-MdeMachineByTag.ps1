function Get-MdeMachineByTag {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, 
      ValueFromPipelineByPropertyName)]
    [string]
    $tag,
    [Parameter(ValueFromPipelineByPropertyName)]
    [boolean]
    $useStartsWithFilter = $false
  )
  return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/machines/findbytag?tag=$tag&useStartsWithFilter=$useStartsWithFilter"
}