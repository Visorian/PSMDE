BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
  Import-Module Az.Accounts, Az.Resources
}

Describe "New-MdeServicePrincipal" {

  It 'Should have the PSMDE module loaded' {
    $module = Get-Module PSMDE
    $module | Should -Not -BeNullOrEmpty
  }

  It 'Should throw when no Azure context is available' {
    InModuleScope PSMDE {
      Mock Get-AzContext { return $null }
      { New-MdeServicePrincipal } | Should -Throw 'No active Az session found, please run Connect-AzAccount first.'
    }
  }

  It 'Should correctly return service principal details' {
    InModuleScope PSMDE {
      $mockSp = @{
        Id          = 'b71b0a5e-22f5-442a-b84c-a6d04ce54b4d'
        AppId       = '7e638cab-c6d3-4a46-8a3b-cac348460d71'
        DisplayName = 'PSMDE'
      }
      Mock Start-Sleep { }
      Mock Get-AzContext { return @{ Tenant = @{ Id = '123' } } }
      Mock New-AzADServicePrincipal { return $mockSp }
      Mock Get-AzADApplication { return $mockSp } 
      Mock Add-AzADAppPermission { }
      $result = New-MdeServicePrincipal -dontOpenGrantUrl
      $result.servicePrincipalName | Should -Be $mockSp.DisplayName
      $result.servicePrincipalId | Should -Be $mockSp.Id
      $result.servicePrincipalApplicationId | Should -Be $mockSp.AppId
      $result.servicePrincipalTenantId | Should -Be '123'
      $result.servicePrincipalSecret | Should -BeNullOrEmpty
      $result.servicePrincipalSecretExpiration | Should -BeNullOrEmpty
      $result.servicePrincipalPermissionsUrl | Should -Be 'https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/CallAnAPI/appId/7e638cab-c6d3-4a46-8a3b-cac348460d71'
    }
  }

  It 'Should correctly initialize module variables' {
    InModuleScope PSMDE {
      $endDate = (Get-Date).AddDays(30)
      $mockSp = @{
        Id          = 'b71b0a5e-22f5-442a-b84c-a6d04ce54b4d'
        AppId       = '7e638cab-c6d3-4a46-8a3b-cac348460d71'
        DisplayName = 'PSMDE'
      }
      $mockSecret = @{
        SecretText  = 'abcdef'
        EndDateTime = $endDate
      }
      Mock Start-Sleep { }
      Mock Get-AzContext { return @{ Tenant = @{ Id = '123' } } }
      Mock New-AzADServicePrincipal { return $mockSp }
      Mock Get-AzADApplication { return $mockSp } 
      Mock Add-AzADAppPermission { }
      Mock New-AzADAppCredential { return $mockSecret }
      Mock Set-MdeAuthorizationInfo { }
      $result = New-MdeServicePrincipal -initialize -dontOpenGrantUrl
      $result.servicePrincipalSecret | Should -Be $mockSecret.SecretText
      $result.servicePrincipalSecretExpiration | Should -Be $endDate
    }
  }
}
