<#
.SYNOPSIS
  List live response library files.

.DESCRIPTION
  List live response library files.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/list-library-files?view=o365-worldwide

.EXAMPLE
  Get-MdeLibraryFiles

.ROLE
  @(@{permission = 'Library.Manage'; permissionType = 'Application'}, @{permission = 'Library.Manage'; permissionType = 'Delegated'})
#>

function Get-MdeLibraryFiles {
  [CmdletBinding()]
  param ()
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
  }
  Process {
    return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/libraryfiles"
  }
  End {}
}
