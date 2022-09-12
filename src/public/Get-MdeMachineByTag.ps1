function Get-MdeMachineByTag {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $tag,
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [boolean]
    $useStartsWithFilter = $false
  )
  return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/machines/findbytag?tag=$tag&useStartsWithFilter=$useStartsWithFilter"
}