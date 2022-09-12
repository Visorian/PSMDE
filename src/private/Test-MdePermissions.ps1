function Test-MdePermissions {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $cmdletName
  )
  $scopes = (Get-MDEAuthorizationInfo).scopes
  $requiredRoles = (Get-Help $cmdletName -Full).role | Invoke-Expression
  $containsRole = $false
  foreach ($role in $requiredRoles) {
    $evaluation = $scopes.contains($role.permission)
    Write-Verbose "Checking for '[$($role.permissionType)] $($role.permission)': $evaluation"
    $containsRole = $containsRole -or $evaluation
  }
  return $containsRole
}
