#Requires -PSEdition Core
#Requires -Version 7.0

<#
.SYNOPSIS
  Creates a service principal (app registration) for Defender for Endpoint.

.DESCRIPTION
  Creates a service principal (app registration) for Defender for Endpoint with a given set of permissions to interact with MDE.

.NOTES
  Author: Jan-Henrik Damaschke

.PARAMETER name
  Optional. Service principal name, defaults to 'PSMDE'.

.PARAMETER permissions
  Optional. Service principal permissions, defaults to 'read'. Possible values are 'read', 'readwrite'. Assigns either all 'Read' or all 'ReadWrite' permissions to the new service principal.

.PARAMETER delegated
  Optional. If defined, the service principal will be created with delegated, not with application permissions.

.PARAMETER initialize
  Optional. If defined, a secret will be generated and the service principal details will be handed over to Set-MdeAuthorizationInfo.

.PARAMETER dontOpenGrantUrl
  Optional. If defined, it will not open a browser after the service principal was created to grant permissions.

.LINK
  https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exposed-apis-create-app-webapp?view=o365-worldwide

.EXAMPLE
  New-MdeServicePrincipal -name 'PSMDE-SP' -permissions 'read' -delegated

.EXAMPLE
  New-MdeServicePrincipal -permissions 'readwrite' -initialize

.EXAMPLE
  New-MdeServicePrincipal -dontOpenGrantUrl
#>

function New-MdeServicePrincipal {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $name = 'PSMDE',
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateSet('read', 'readwrite')] 
    [string]
    $permissions = 'read',
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [switch]
    $delegated,
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [switch]
    $initialize,
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [switch]
    $dontOpenGrantUrl
  )
  Begin {
    $mdeIdAppId = 'fc780465-2017-40d4-a0c5-307022471b92'
    $applicationReadRoles = @(
      @{name = 'AdvancedQuery.Read.All'; id = '93489bf5-0fbc-4f2d-b901-33f2fe08ff05' }
      @{name = 'Alert.Read.All'; id = '71fe6b80-7034-4028-9ed8-0f316df9c3ff' }
      @{name = 'File.Read.All'; id = '8788f1a9-beca-4e26-ba58-10513f3b896f' }
      @{name = 'Ip.Read.All'; id = '47bf842d-354b-49ef-b741-3a6dd815bc13' }
      @{name = 'Machine.Read.All'; id = 'ea8291d3-4b9a-44b5-bc3a-6cea3026dc79' }
      @{name = 'RemediationTasks.Read.All'; id = '6a33eedf-ba73-4e5a-821b-f057ef63853a' }
      @{name = 'Score.Read.All'; id = '02b005dd-f804-43b4-8fc7-078460413f74' }
      @{name = 'SecurityBaselinesAssessment.Read.All'; id = 'e870c0c1-c1a2-41ca-948e-a33912d2d3f0' }
      @{name = 'SecurityConfiguration.Read.All'; id = '227f2ea0-c2c2-4428-b7af-9ff40f1a720e' }
      @{name = 'SecurityRecommendation.Read.All'; id = '6443965c-7dd2-4cfd-b38f-bb7772bee163' }
      @{name = 'Software.Read.All'; id = '37f71c98-d198-41ae-964d-2c49aab74926' }
      @{name = 'Ti.Read.All'; id = '528ca142-c849-4a5b-935e-10b8b9c38a84' }
      @{name = 'Url.Read.All'; id = '721af526-ffa8-42d7-9b84-1a56244dd99d' }
      @{name = 'User.Read.All'; id = 'a833834a-4cf1-4732-8acf-bbcfa13fb610' }
      @{name = 'Vulnerability.Read.All'; id = '41269fc5-d04d-4bfd-bce7-43a51cea049a' }
    )
    $applicationReadWriteRoles = @(
      @{name = 'AdvancedQuery.Read.All'; id = '93489bf5-0fbc-4f2d-b901-33f2fe08ff05' }
      @{name = 'Alert.ReadWrite.All'; id = '0f7000ec-157b-497f-b70e-ef0b0584f140' }
      @{name = 'Event.Write'; id = '84ddd701-5fac-4c30-b0ad-aa73a67bea1a' }
      @{name = 'File.Read.All'; id = '8788f1a9-beca-4e26-ba58-10513f3b896f' }
      @{name = 'IntegrationConfiguration.ReadWrite'; id = '7c6f6912-60e9-4fcd-bb2a-c25bc35e8c59' }
      @{name = 'Ip.Read.All'; id = '47bf842d-354b-49ef-b741-3a6dd815bc13' }
      @{name = 'Library.Manage'; id = '41d209c7-2511-4fc9-b899-8008a3976f09' }
      @{name = 'Machine.ReadWrite.All'; id = 'aa027352-232b-4ed4-b963-a705fc4d6d2c' }
      @{name = 'RemediationTasks.Read.All'; id = '6a33eedf-ba73-4e5a-821b-f057ef63853a' }
      @{name = 'Score.Read.All'; id = '02b005dd-f804-43b4-8fc7-078460413f74' }
      @{name = 'SecurityBaselinesAssessment.Read.All'; id = 'e870c0c1-c1a2-41ca-948e-a33912d2d3f0' }
      @{name = 'SecurityConfiguration.ReadWrite.All'; id = 'e5e05709-32a3-4c85-89c8-67596eb94f24' }
      @{name = 'SecurityRecommendation.Read.All'; id = '6443965c-7dd2-4cfd-b38f-bb7772bee163' }
      @{name = 'Software.Read.All'; id = '37f71c98-d198-41ae-964d-2c49aab74926' }
      @{name = 'Ti.ReadWrite.All'; id = 'fc511a58-3adf-4d71-af24-00f13e35e479' }
      @{name = 'Url.Read.All'; id = '721af526-ffa8-42d7-9b84-1a56244dd99d' }
      @{name = 'User.Read.All'; id = 'a833834a-4cf1-4732-8acf-bbcfa13fb610' }
      @{name = 'Vulnerability.Read.All'; id = '41269fc5-d04d-4bfd-bce7-43a51cea049a' }
    )
    $delegatedReadRoles = @(
      @{name = 'AdvancedQuery.Read'; id = '1fb6e712-1bd9-4184-b1c0-5e71e759196b' }
      @{name = 'Alert.Read'; id = 'b2069dc0-9fe9-4e6d-9aca-ccf3dd503819' }
      @{name = 'File.Read.All'; id = '8fce64a0-67c8-4e39-8f47-cac9ff7e13bb' }
      @{name = 'Ip.Read.All'; id = 'b65a97e8-c8e8-4908-b19a-f654615de1a9' }
      @{name = 'Machine.Read'; id = 'fbd3d33a-b1f5-4573-906c-51b39682fbcf' }
      @{name = 'RemediationTasks.Read'; id = '19956c04-168f-4f44-b471-48c8f50dc0c8' }
      @{name = 'Score.Read'; id = 'df4ed126-3a4c-460a-b0fc-67aea84fc332' }
      @{name = 'SecurityBaselinesAssessment.Read'; id = 'd42e2aa1-a664-43a9-b7c6-2766d44a6687' }
      @{name = 'SecurityConfiguration.Read'; id = '4ac83e46-552f-4948-91c2-f7eaff971018' }
      @{name = 'SecurityRecommendation.Read'; id = '1ab96238-1253-4059-a32f-4087f20ed65d' }
      @{name = 'Software.Read'; id = '5f216ada-3f51-4a22-ace5-06b198328476' }
      @{name = 'Url.Read.All'; id = '42b4777c-6196-49ad-9cfc-207e73f2eb61' }
      @{name = 'User.Read.All'; id = 'ffd6563e-842b-4cfc-b349-06006e0473a3' }
      @{name = 'Vulnerability.Read'; id = '63a677ce-818c-4409-9d12-5c6d2e2a6bfe' }
    )
    $delegatedReadWriteRoles = @(
      @{name = 'AdvancedQuery.Read'; id = '1fb6e712-1bd9-4184-b1c0-5e71e759196b' }
      @{name = 'Alert.ReadWrite'; id = 'cbc3b413-21e6-416d-95a4-af87687efbd0' }
      @{name = 'File.Read.All'; id = '8fce64a0-67c8-4e39-8f47-cac9ff7e13bb' }
      @{name = 'IntegrationConfiguration.ReadWrite'; id = '7c6f6912-60e9-4fcd-bb2a-c25bc35e8c59' }
      @{name = 'Ip.Read.All'; id = 'b65a97e8-c8e8-4908-b19a-f654615de1a9' }
      @{name = 'Library.Manage'; id = '5998a3da-2c9b-4bf3-99bd-44c9fe337ad2' }
      @{name = 'Machine.ReadWrite'; id = 'f6846c57-9e3c-4a65-81aa-2f5e09ff4f0b' }
      @{name = 'RemediationTasks.Read'; id = '19956c04-168f-4f44-b471-48c8f50dc0c8' }
      @{name = 'Score.Read'; id = 'df4ed126-3a4c-460a-b0fc-67aea84fc332' }
      @{name = 'SecurityBaselinesAssessment.Read'; id = 'd42e2aa1-a664-43a9-b7c6-2766d44a6687' }
      @{name = 'SecurityConfiguration.ReadWrite'; id = 'bfc81a3a-4f6d-4bfe-b945-d7fe6747d2a0' }
      @{name = 'SecurityRecommendation.Read'; id = '1ab96238-1253-4059-a32f-4087f20ed65d' }
      @{name = 'Software.Read'; id = '5f216ada-3f51-4a22-ace5-06b198328476' }
      @{name = 'Ti.ReadWrite'; id = '650ff1f9-dd5f-48ee-8c58-7beef332c818' }
      @{name = 'Url.Read.All'; id = '42b4777c-6196-49ad-9cfc-207e73f2eb61' }
      @{name = 'User.Read.All'; id = 'ffd6563e-842b-4cfc-b349-06006e0473a3' }
      @{name = 'Vulnerability.Read'; id = '63a677ce-818c-4409-9d12-5c6d2e2a6bfe' }
    )
  }
  Process {
    $context = (Get-AzContext)
    if ($context) {
      $sp = New-AzADServicePrincipal -DisplayName $name
      # Wait for Azure AD
      Write-Verbose 'Waiting 5 seconds for the app to be available in Azure AD'
      Start-Sleep -Seconds 5
      $sp = Get-AzADApplication -ApplicationId $sp.AppId
      if ($delegated) {
        $permissionSet = $permissions -eq 'read' ? $delegatedReadRoles : $delegatedReadWriteRoles
        foreach ($permission in $permissionSet) {
          Add-AzADAppPermission -ObjectId $sp.Id -ApiId $mdeIdAppId -PermissionId $permission.id -Type Scope
        }
      }
      else {
        $permissionSet = $permissions -eq 'read' ? $applicationReadRoles : $applicationReadWriteRoles
        foreach ($permission in $permissionSet) {
          Add-AzADAppPermission -ObjectId $sp.Id -ApiId $mdeIdAppId -PermissionId $permission.id -Type Role
        }
      }
      # Wait for Azure AD
      Write-Verbose 'Waiting 5 seconds for the app permissions to be applied in Azure AD'
      Start-Sleep -Seconds 5
      if ($initialize) {
        $secret = $sp | New-AzADAppCredential -EndDate (Get-Date).AddDays(30)
        Set-MdeAuthorizationInfo -tenantId $context.Tenant.Id -appId $sp.AppId -appSecret $secret.SecretText -noTokenRefresh
        $script:initialize = $true
      }
      $grantUrl = "https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/CallAnAPI/appId/$($sp.AppId)"
      if (-not $dontOpenGrantUrl) { Start-Process $grantUrl }
      Write-Output "Please grant consent for the provided API permissions. The first execution of a function can take a few seconds, as the grants are not immediatly available."
      return @{
        servicePrincipalName             = $sp.DisplayName
        servicePrincipalId               = $sp.Id
        servicePrincipalApplicationId    = $sp.AppId
        servicePrincipalTenantId         = $context.Tenant.Id
        servicePrincipalSecret           = ${secret}?.SecretText
        servicePrincipalSecretExpiration = ${secret}?.EndDateTime
        servicePrincipalPermissionsUrl   = $grantUrl
      }
    }
    else {
      Throw 'No active Az session found, please execute Connect-AzAccount first.'
    }
  }
  End {}
}
