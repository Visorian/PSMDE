# Microsoft Defender for Endpoint (MDE) PowerShell module

[![ci](https://github.com/Visorian/PSMDE/actions/workflows/ci.yml/badge.svg)](https://github.com/Visorian/PSMDE/actions/workflows/ci.yml)
[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/PSMDE)](https://www.powershellgallery.com/packages/PSMDE)
![Code Coverage](https://img.shields.io/badge/coverage-37.94%25-yellow)

## Installation

```PowerShell
Install-Module PSMDE
```

## First steps

This module is optimized for unattended use, so you need to provide a service principal to authenticate against the MDE API.
The detailed process to create a service principal with the correct roles is explained [here](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exposed-apis-create-app-webapp?view=o365-worldwide).

When the service principal is created, they will be used in the session to authenticate and refresh the token if necessary. To initialize or update the session authentication information, the `Set-MdeAuthorizationInfo` function is used.

```PowerShell
Set-MdeAuthorizationInfo -tenantId '00000000-0000-0000-0000-000000000000' -appId '00000000-0000-0000-0000-000000000000' -appSecret 'APP_SECRET'
```

Currently, it's not supported to authenticate via environment variables, this is planned for a future release.

## Token refresh

The module will verify the expiration of the current token on every request and will acquire a new one as soon as the existing one has less than 5 minutes life time left. To manually initialize a token refresh, e.g. when adjusting the permission roles, execute `Clear-MdeAuthorizationInfo` and set it again with `Set-MdeAuthorizationInfo -tenantId '00000000-0000-0000-0000-000000000000' -appId '00000000-0000-0000-0000-000000000000' -appSecret 'APP_SECRET'`.
You can alway get the current roles of your active token using the `Get-MdeAuthorizationInfo` function.

## Permission roles

To vaerify the current roles of the active token, execute ``
This will return a object with a `tokenExpire` and a `roles` field:

```PowerShell
Name                           Value
----                           -----
tokenExpired                   False
roles                         {Url.Read.All, Ip.Read.All, Ti.Read.All, User.Read.All?}
```

Each function will check, if the current token roles include at least one of the roles needed for the respective function. To get the needed roles for a specific function, you can use the `Get-MdeRoles -functionName 'Add-MdeMachineTag'` function.
