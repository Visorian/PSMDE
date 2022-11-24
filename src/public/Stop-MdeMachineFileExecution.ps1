<#
.SYNOPSIS
  Stop execution of a file on a device and delete it.

.DESCRIPTION
  Stop execution of a file on a device and delete it. Adds file to quarantine.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/stop-and-quarantine-file?view=o365-worldwide

.PARAMETER id
  Specifies the id of the target MDE machine.

.PARAMETER comment
  Comment to associate with the action.

.PARAMETER sha1
  Sha1 of the file to stop and quarantine on the device.

.EXAMPLE
  Remove-MdeMachine -id "MACHINE_ID" -comment "Your comment" -sha1 'F8DAE85E2EEE4AA846D655670947E5C98B83B791'

.ROLE
  @(@{permission = 'Machine.StopAndQuarantine'; permissionType = 'Application'}, @{permission = 'Machine.ReadWrite.All'; permissionType = 'Application'}, @{permission = 'Machine.Read.All'; permissionType = 'Application'}, @{permission = 'Machine.StopAndQuarantine'; permissionType = 'Delegated'})
#>

function Stop-MdeMachineFileExecution {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id,
    [Parameter(Mandatory)]
    [string]
    $comment,
    [Parameter(Mandatory)]
    [string]
    $sha1
  )
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
  }
  Process {
    return Invoke-RetryRequest -Method Post -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/StopAndQuarantineFile" -body (ConvertTo-Json -InputObject @{ Comment = $comment; Sha1 = $sha1 })
  }
  End {}
}