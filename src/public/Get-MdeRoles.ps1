<#
.SYNOPSIS
  List roles for a given function.

.DESCRIPTION
  Lists required roles and current token roles for a specific function from this module.

.NOTES
  Author: Jan-Henrik Damaschke

.EXAMPLE
  Get-MdeRoles -functionName 'Get-MdeMachine'
#>

function Get-MdeRoles {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $functionName
  )
  try {
    $null = Get-Command $functionName -ErrorAction Stop
    return Test-MdePermissions -functionName $functionName -detailed
  }
  catch {
    Throw "Invalid function name"
  }
}
