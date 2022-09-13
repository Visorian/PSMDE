# Microsoft Defender for Endpoint (MDE) PowerShell module

[![ci](https://github.com/Visorian/PSMDE/actions/workflows/ci.yml/badge.svg)](https://github.com/Visorian/PSMDE/actions/workflows/ci.yml)
![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/PSMDE)

## Installation

```PowerShell
Install-Module PSMDE
```

## First steps

This module is optimized for unattended use, so you need to provide a service principal to authenticate against the MDE API.
The detailed process to create a service principal with the correct scopes is explained [here](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exposed-apis-create-app-webapp?view=o365-worldwide).

When the service principal is created, they will be used in the session to authenticate and refresh the token if necessary. To initialize or update the session authentication information, the `Set-MdeAuthorizationInfo` function is used.

```PowerShell
Set-MdeAuthorizationInfo -tenantId '00000000-0000-0000-0000-000000000000' -appId '00000000-0000-0000-0000-000000000000' -appSecret 'APP_SECRET'
```

Currently, it's not supported to authenticate via environment variables, this is planned for a later release.
