<#
.SYNOPSIS
  Retrieves the organization software inventory.

.DESCRIPTION
  Retrieves the organization software inventory.

.NOTES
  Author: Jan-Henrik Damaschke

.PARAMETER id
  Optional. Specifies the id of the target MDE machine.

.PARAMETER name
  Optional. Specifies the id of the target MDE machine.

.PARAMETER vendor
  Optional. Specifies the id of the target MDE machine.

.OUTPUTS
  PSCustomObject. The Get-MdeMachine function returns a list of or a single PSCustomObject containing the parsed MDE machine object.

.EXAMPLE
  $software = Get-MdeSoftware
  
.EXAMPLE
  $software = Get-MdeSoftware -id 'microsoft-_-edge' -name 'edge'
  
.EXAMPLE
  $software = Get-MdeSoftware -vendor 'microsoft'

.ROLE
  @(@{permission = 'Software.Read.All'; permissionType = 'Application'}, @{permission = 'Software.Read'; permissionType = 'Delegated'})
#>

function Get-MdeSoftware {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id,
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $name,
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $vendor
  )
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
  }
  Process {
    if (-not $id -and -not $name -and -not $vendor) {
      return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/Software"
    }
    else {
      $uri = 'https://api.securitycenter.microsoft.com/api/machines?$filter={0}{1}{2}' -f ($id ? "id eq '$id' and " : ''), ($name ? "name eq '$name' and " : ''), ($vendor ? "vendor eq '$vendor'" : '')
      $null = $uri.EndsWith(' and ') && ($uri = $uri.TrimEnd(' and '))
      return Invoke-RetryRequest -Method Get -Uri $uri
    }
  }
  End {}
}