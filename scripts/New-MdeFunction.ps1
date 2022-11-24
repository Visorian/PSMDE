<#
.SYNOPSIS
  Creates a new MDE function and test file
#>

[CmdletBinding()]
param (
  [Parameter(Mandatory)]
  [string]
  $name,
  [Parameter(Mandatory)]
  [ValidateSet('public', 'private')]  
  [string]
  $scope,
  [string]
  $description = 'Please fill in'
)
$functionBody = @"
<#
.SYNOPSIS
  $description

.DESCRIPTION
  $description

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/...

.PARAMETER id
  Optional. Specifies the id of the target MDE recommendation.

.EXAMPLE
  `$result = $name

.EXAMPLE
  $name -id "<GUID>"

.EXAMPLE
  $name -filter "`$filter=vendor+eq+'microsoft'"

.ROLE
  @(@{permission = ''; permissionType = 'Application'}, @{permission = ''; permissionType = 'Delegated'})
#>

function $name {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    `$id
  )
  Begin {
    if (-not (Test-MdePermissions -functionName `$PSCmdlet.CommandRuntime)) {
      `$requiredRoles = (Get-Help `$PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: `$(`$requiredRoles.permission)"
    }
  }
  Process {
    return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/"
  }
  End {}
}
"@
$srcFileName = "../src/$scope/$name.ps1"
$testFileName = "../tests/$scope/$name.Tests.ps1"
$srcFile = New-Item $srcFileName
$functionBody | Out-File -Append -FilePath $srcFile.FullName -Force
New-Item $testFileName
