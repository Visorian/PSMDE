function Test-MdePermissions {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $functionName,
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [switch]
    $detailed = $false
  )
  $roles = (Get-MdeAuthorizationInfo).roles
  $requiredRoles = (Get-Help $functionName -Full).role | Invoke-Expression
  $containsRole = $false
  foreach ($role in $requiredRoles) {
    $evaluation = $roles.contains($role.permission)
    Write-Verbose "Checking for '[$($role.permissionType)] $($role.permission)': $evaluation"
    $containsRole = $containsRole -or $evaluation
  }
  if ($detailed) {
    return @{
      validTokenPermission = $containsRole
      requiredRoles        = $requiredRoles.permission
      currentRoles         = $roles
    }
  }
  return $containsRole
}
