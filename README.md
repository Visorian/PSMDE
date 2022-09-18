![PSMDE Banner](/icon/banner.png)

# Microsoft Defender for Endpoint (MDE) PowerShell module

[![ci](https://github.com/Visorian/PSMDE/actions/workflows/ci.yml/badge.svg)](https://github.com/Visorian/PSMDE/actions/workflows/ci.yml)
[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/PSMDE)](https://www.powershellgallery.com/packages/PSMDE)
![Code Coverage](https://img.shields.io/badge/coverage-59.96%25-yellow)

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
- Get-MdeAuthorizationInfo
- Get-MdeMachine
- Get-MdeMachineAlerts
- Get-MdeMachineByFilter
- Get-MdeMachineByIp
- Get-MdeMachineByTag
- Get-MdeMachineLogonUsers
- Get-MdeMachineMissingKbs
- Get-MdeMachineRecommendations
- Get-MdeMachineSoftware
- Get-MdeMachineVulnerabilities
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
- New-MdeServicePrincipal
- Remove-MdeMachineTag
- Set-MdeAuthorizationInfo
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

## Contributing

Thanks for your interest in contributing, all contributions are welcome and this section should help you get started.

### Local setup

- Clone this repository
- Make sure you have PSScriptAnalyzer and Pester as well as PowerShell 7+ installed. We recommend using VSCode.
- Check out a new branch for your contribution (`git checkout -b 'feature/fantastic-new-function'`)

### Commit convention

Before contributing, you should be familiar with the following concepts:

- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [gitmoji](https://gitmoji.dev/) - Usage of gitmoji is optional, but highly preferred. It's helping a lot with identifying the exact type of commit on first sight and has basically no overhead when using tools like `gacp`

To create valid commit messages, you have to use conventional commits. For the type, it's preferred to use emojis with optional text and to use scopes where possible. We use the following defined types with optional scopes to be able to comply with semver and make automatic CHANGELOG generation and tagging/versioning possible:

- build
- chore
- ci
- docs
- feat
- fix
- perf
- refactor
- revert
- style
- test

We recommend to use a tool like [gitmoji-cli](https://github.com/carloscuesta/gitmoji-cli) or [gacp](https://github.com/vivaxy/gacp) to make following these requirements easier.

Note that `fix:` and `feat:` are for code changes. For typo or document changes, use `docs:` or `chore:` instead.

### Pull request

If you finished your change, you can create a pull request (PR) to get them merged. If you are not familiar with the process, GitHub has a [guide on PRs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request).

:warning: **Before creatign a PR, please make sure that no tests are failing (`Invoke-Pester`) and PSScriptAnalyzer (`Invoke-ScriptAnalyzer -Path .\ -Settings PSGallery -Recurse -Severity Error`) doesn't return any errors.**

Make sure, you have updated the wiki submodule in the `wiki` folder:

```PowerShell
Set-Location wiki
git pull
Set-Location ..
```

If you are closing issues with a PR, please reference the issues in the PR description (`fix/fixes #123` where 123 is the issue id).

## License

Made with :heart:

Published under [MIT License](./LICENCE).




