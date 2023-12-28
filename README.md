![PSMDE Banner](/icon/banner.png)

# Microsoft Defender for Endpoint (MDE) PowerShell module

![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/Visorian/PSMDE/ci.yml?logo=github&label=CI%2FCD&labelColor=181818)
![PowerShell Gallery Version (including pre-releases)](https://img.shields.io/powershellgallery/v/PSMDE?labelColor=181818&color=4578d2&label=PS%20Gallery%20Version)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/PSMDE?labelColor=181818&color=4578d2&label=PS%20Gallery%20Downloads)
![Code Coverage](https://img.shields.io/badge/coverage-93.75%25-yellow?labelColor=181818&color=4578d2&label=Test%20Coverage)

## Installation

```PowerShell
Install-Module PSMDE
```

## First steps

### Service principal creation

This module is optimized for unattended use, so you need to provide a service principal to authenticate against the MDE API.
The detailed process to create a service principal with the correct roles is explained [here](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exposed-apis-create-app-webapp?view=o365-worldwide).

You can use the helper function `New-MdeServicePrincipal` to create a app registration with the needed permissions:

:warning: **`New-MdeServicePrincipal` uses your current Azure session. If there is no current Azure context (verify with `Get-AzContext`), execution will fail. This way you can use it e.g. with the [Azure Login Github Action](https://github.com/marketplace/actions/azure-login)** or your current logged in Azure session on you computer.

```PowerShell
New-MdeServicePrincipal

Name                             Value
----                             -----
servicePrincipalSecret           
servicePrincipalId               12345678-1234-1234-1234-123456789012
servicePrincipalName             PSMDE
servicePrincipalTenantId         12345678-1234-1234-1234-123456789012
servicePrincipalApplicationId    12345678-1234-1234-1234-123456789012
servicePrincipalPermissionsUrl   https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/CallAnA
servicePrincipalSecretExpiration 
```

To also create a secret and add it to the current session credentials automatically, specify the `-initialize` parameter.

```PowerShell
New-MdeServicePrincipal -initialize

Name                             Value
----                             -----
servicePrincipalSecret           abc123
servicePrincipalId               12345678-1234-1234-1234-123456789012
servicePrincipalName             PSMDE
servicePrincipalTenantId         12345678-1234-1234-1234-123456789012
servicePrincipalApplicationId    12345678-1234-1234-1234-123456789012
servicePrincipalPermissionsUrl   https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/CallAnA
servicePrincipalSecretExpiration 10/18/2022 14:20:02
```

:warning: **The created secret is only valid for 30 days. If you need a longer lasting secret, please create a new one in the Azure portal or using `New-AzADAppCredential`.**

By default, the `New-MdeServicePrincipal` adds all available `Read.All` or `Read` application permission. If you need to use delegated permissions, use the `-delegated` parameter.
To also add permissions for write operations, add the `-permissions 'readwrite'` parameter.

After the creation, `New-MdeServicePrincipal` will automatically open a browser with the service principals API page to grant permissions. If you don't want this, add the `-dontOpenGrantUrl` parameter, but **don't forget to grant you service principal permissions before using it**.

### Authentication

After you created the service principal or used the `New-MdeServicePrincipal` function, you need to add the credentials to the current session to authenticate and refresh the token if necessary (unless you used `New-MdeServicePrincipal -initialize`). To initialize or update the session authentication information, use the `Set-MdeAuthorizationInfo` function.

```PowerShell
Set-MdeAuthorizationInfo -tenantId '00000000-0000-0000-0000-000000000000' -appId '00000000-0000-0000-0000-000000000000' -appSecret 'APP_SECRET'
```

If you added new scopes or want to manually refresh the token before expiration, use the `Clear-MdeAuthorizationInfo` function and add the credentials again with `Set-MdeAuthorizationInfo`.

Currently, it's not supported to authenticate via environment variables, this is planned for a future release.

## Token refresh

The module will verify the expiration of the current token on every request and will acquire a new one as soon as the existing one has less than 5 minutes life time left. To manually initialize a token refresh, e.g. when adjusting the permission roles, execute `Clear-MdeAuthorizationInfo` and set it again with `Set-MdeAuthorizationInfo -tenantId '00000000-0000-0000-0000-000000000000' -appId '00000000-0000-0000-0000-000000000000' -appSecret 'APP_SECRET'`.
You can alway get the current roles of your active token using the `Get-MdeAuthorizationInfo` function.

## Permission roles

To verify the current roles of the active token, execute ``
This will return a object with a `tokenExpire` and a `roles` field:

```PowerShell
Name                           Value
----                           -----
tokenExpired                   False
roles                          { Url.Read.All, Ip.Read.All, Ti.Read.All, User.Read.All }
```

Each function will check, if the current token roles include at least one of the roles needed for the respective function. To get the needed roles for a specific function, you can use the `Get-MdeRoles -functionName 'Add-MdeMachineTag'` function.

## Usage examples

You can find help for all available functions in the [wiki](https://github.com/Visorian/PSMDE/wiki/PSMDE) or by using the PowerShell integrated help.
These section provides an overview of the available functions and some examples for common MDE scenarios (contributions welcome).

### Available functions

<details>
<summary>Function list</summary>

- Add-MdeMachineTag
- Clear-MdeAuthorizationInfo
- Disable-MdeMachineCodeExecutionRestriction
- Disable-MdeMachineIsolation
- Enable-MdeMachineCodeExecutionRestriction
- Enable-MdeMachineIsolation
- Get-MdeAuthorizationInfo
- Get-MdeBaselineComplianceAssessmentByMachine
- Get-MdeBaselineComplianceAssessmentExport
- Get-MdeBaselineConfiguration
- Get-MdeBaselineProfile
- Get-MdeConfigurationScore
- Get-MdeExposureScore
- Get-MdeExposureScoreByMachineGroups
- Get-MdeLibraryFiles
- Get-MdeLiveResponseResult
- Get-MdeMachine
- Get-MdeMachineAction
- Get-MdeMachineAlerts
- Get-MdeMachineByFilter
- Get-MdeMachineByIp
- Get-MdeMachineByTag
- Get-MdeMachineInvestigationPackage
- Get-MdeMachineInvestigationPackageUri
- Get-MdeMachineLogonUsers
- Get-MdeMachineMissingKbs
- Get-MdeMachineRecommendations
- Get-MdeMachineSoftware
- Get-MdeMachineVulnerabilities
- Get-MdeRecommendation
- Get-MdeRecommendationMachines
- Get-MdeRecommendationSoftware
- Get-MdeRecommendationVulnerabilities
- Get-MdeRemediationTask
- Get-MdeRemediationTaskMachines
- Get-MdeRoles
- Get-MdeSoftware
- Get-MdeSoftwareByFilter
- Get-MdeSoftwareDistribution
- Get-MdeSoftwareMachineReferences
- Get-MdeSoftwareMissingKbs
- Get-MdeSoftwareVulnerability
- Get-MdeUserAlerts
- Get-MdeUserMachines
- Get-MdeVulnerability
- Get-MdeVulnerabilityByMachine
- Get-MdeVulnerabilityMachinesByVulnerability
- Invoke-MdeMachineAntivirusScan
- Invoke-MdeMachineLiveResponse
- New-MdeServicePrincipal
- Remove-MdeMachine
- Remove-MdeMachineTag
- Set-MdeAuthorizationInfo
- Stop-MdeMachineAction
- Stop-MdeMachineFileExecution
- Update-MdeMachine

</details>

### Get all MDE servers and add the `computername` attribute

```PowerShell
$machines = Get-MdeMachine
$mdeMachines = $machines | Where-Object { @('WindowsServer2022', 'WindowsServer2019', 'WindowsServer2016', 'WindowsServer2012R2', 'WindowsServer2008R2') -contains $_.osPlatform } | Select-Object -Property *, @{Name = 'computerName'; Expression = { $_.computerDnsName.split('.')[0] } }
```

### Add a tag to multiple MDE machines

```PowerShell
$tag = 'monitoring-onboarded'
$machines = Get-MdeMachines
$fitleredMachines = $machines | Where-Object { $_.computerDnsName.endsWith('.mydomain.local') } | Where-Object { $_.healthStatus -eq 'Active' }
$fitleredMachines | Add-MdeMachineTag -tag $tag
```

## Contribution

See [Contributing Guide](https://github.com/Visorian/PSMDE/blob/main/CONTRIBUTING.md).

## License

Made with :heart:

Published under [MIT License](./LICENCE).

