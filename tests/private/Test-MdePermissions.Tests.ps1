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
      Mock Get-MdeAuthorizationHeader { }
      Mock Get-MdeAuthorizationInfo { return @{roles = @('Machine.Read.All', 'User.Read.All') } }
      Test-MdePermissions -functionName 'Get-MdeMachine'
      Should -Invoke Get-MdeAuthorizationInfo
    }
  }

  It 'Should return true, if roles are in token' {
    InModuleScope PSMDE {
      Mock Get-MdeAuthorizationHeader { }
      Mock Get-MdeAuthorizationInfo { return @{roles = @('Machine.Read.All', 'User.Read.All') } }
      Test-MdePermissions -functionName 'Get-MdeMachine' | Should -Be $true
    }
  }

  It 'Should return false, if roles not in token' {
    InModuleScope PSMDE {
      Mock Get-MdeAuthorizationHeader { }
      Mock Get-MdeAuthorizationInfo { return @{roles = @('User.Read.All') } }
      Test-MdePermissions -functionName 'Get-MdeMachine' | Should -Be $false
    }
  }

  It 'Should return object, when detailed parameter is specified' {
    InModuleScope PSMDE {
      $permissions = @{
        validTokenPermission = $false
        requiredRoles        = @('Machine.Read.All', 'Machine.ReadWrite.All', 'Machine.Read', 'Machine.ReadWrite')
        currentRoles         = @('User.Read.All')
      }
      Mock Get-MdeAuthorizationHeader { }
      Mock Get-MdeAuthorizationInfo { return @{roles = @('User.Read.All') } }
      $result = Test-MdePermissions -functionName 'Get-MdeMachine' -detailed
      $result | Should -BeOfType Hashtable
      foreach ($key in $result.Keys) {
        if ($result[$key].gettype() -eq [Object[]]) {
          $result[$key] | ForEach-Object { $permissions[$key] -contains $_ | Should -Be $true }
        }
        else {
          Should -Be -ActualValue $result[$key] -ExpectedValue $permissions[$key]
        }
      }
    }
  }
}
