<#
.SYNOPSIS
  Initiate Microsoft Defender Antivirus scan on a device.

.DESCRIPTION
  Initiate Microsoft Defender Antivirus scan on a device.

.NOTES
  Author: Jan-Henrik Damaschke

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/...

.PARAMETER id
  Specifies the id of the target MDE machine.

.PARAMETER comment
  Comment to associate with the action.

.PARAMETER scanType
  Optional. Defines the type of the Scan. Required. Allowed values are: 'Quick' or 'Full' (default: 'Quick').

.EXAMPLE
  Invoke-MdeMachineAntivirusScan -id "MACHINE_ID" -comment "Your comment"

.EXAMPLE
  Invoke-MdeMachineAntivirusScan -id "MACHINE_ID" -comment "Your comment" -scanType 'Full'

.ROLE
  @(@{permission = 'Machine.Scan'; permissionType = 'Application'}, @{permission = 'Machine.Scan'; permissionType = 'Delegated'})
#>

function Invoke-MdeMachineAntivirusScan {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id,
    [Parameter(Mandatory)]
    [string]
    $comment,
    [Parameter()]
    [ValidateSet('Quick', 'Full')]
    [string]
    $scanType = 'Quick'
  )
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
  }
  Process {
    return Invoke-RetryRequest -Method Post -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/runAntiVirusScan" -body (ConvertTo-Json -InputObject @{ Comment = $comment; ScanType = $scanType })
  }
  End {}
}
