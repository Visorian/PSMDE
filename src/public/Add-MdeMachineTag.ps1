<#
.SYNOPSIS
  Adds tag to a specific Machine.

.DESCRIPTION
  Adds tag to a specific Machine.

.NOTES
  Author: Jan-Henrik Damaschke

.EXAMPLE
  Add-MdeMachineTag -id '123' -tag 'Tag-1'

.ROLE
  @(@{permission = 'Machine.ReadWrite.All'; permissionType = 'Application'}, @{permission = 'Machine.ReadWrite'; permissionType = 'Delegated'})
#>

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
  if (Test-MdePermissions -cmdletName $PSCmdlet.CommandRuntime) {
    $body = @{
      Value  = $tag
      Action = 'Add'
    }
    return Invoke-RetryRequest -Method Post -body (ConvertTo-Json -InputObject $body) -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/tags"
  } else {
    $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
    Write-Error "Missing required permissions. Please check if one of these is in token scope: $($requiredRoles.permission)"
  }
}
