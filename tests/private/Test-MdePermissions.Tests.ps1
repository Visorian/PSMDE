BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('private', 'PSMDE.psd1')
}

Describe 'Test-MdePermissions' {
  It 'Should have the PSMDE module loaded' {
    $module = Get-Module PSMDE
    $module | Should -Not -BeNullOrEmpty
  }

  It 'Should have access to internal functions' {
    InModuleScope PSMDE {
      $cmd = Get-Command Test-MdePermissions
      $cmd | Should -Not -BeNullOrEmpty
    }
  }

  It 'Should call Get-MdeAuthorizationInfo' {
    InModuleScope PSMDE {
      Mock Get-MdeAuthorizationInfo { return @{scopes = @('Machine.Read.All', 'User.Read.All') } }
      Test-MdePermissions -cmdletName 'Get-MdeMachine'
      Should -Invoke Get-MdeAuthorizationInfo
    }
  }

  It 'Should resolve roles correctly' {
    $cmdletRoles = @(@{permission = 'Machine.Read.All'; permissionType = 'Application' }, @{permission = 'Machine.ReadWrite.All'; permissionType = 'Application' }, @{permission = 'Machine.Read'; permissionType = 'Delegated' }, @{permission = 'Machine.ReadWrite'; permissionType = 'Delegated' })
    $requiredRoles = (Get-Help 'Get-MdeMachine' -Full).role | Invoke-Expression
    $requiredRoles.Values | Should -Be $cmdletRoles.Values
  }

  It 'Should return true, if scopes are in token' {
    InModuleScope PSMDE {
      Mock Get-MdeAuthorizationInfo { return @{scopes = @('Machine.Read.All', 'User.Read.All') } }
      Test-MdePermissions -cmdletName 'Get-MdeMachine' | Should -Be $true
    }
  }

  It 'Should return false, if scopes not in token' {
    InModuleScope PSMDE {
      Mock Get-MdeAuthorizationInfo { return @{scopes = @('User.Read.All') } }
      Test-MdePermissions -cmdletName 'Get-MdeMachine' | Should -Be $false
    }
  }
}