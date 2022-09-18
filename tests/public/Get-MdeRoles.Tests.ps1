BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Get-MdeRoles" {

  It 'Should have the PSMDE module loaded' {
    $module = Get-Module PSMDE
    $module | Should -Not -BeNullOrEmpty
  }

  It 'Should call Get-MdeAuthorizationInfo' {
    InModuleScope PSMDE {
      Mock Get-MdeAuthorizationHeader { }
      Mock Get-MdeAuthorizationInfo { return @{roles = @('Machine.Read.All', 'User.Read.All') } }
      Test-MdePermissions -functionName 'Get-MdeMachine'
      Should -Invoke Get-MdeAuthorizationInfo
    }
  }

  It 'Should return the correct roles of a function' {
    InModuleScope PSMDE {
      Mock Get-MdeAuthorizationHeader { }
      Mock Get-MdeAuthorizationInfo { return @{roles = @('Machine.ReadWrite.All', 'Machine.ReadWrite') } }
      $result = Get-MdeRoles -functionName 'Add-MdeMachineTag'
      $result.Keys | ForEach-Object { @('validTokenPermission', 'currentRoles', 'requiredRoles') -contains $_ | Should -Be $true }
    }
  }

  It 'Should throw when a invalid fucntionName is given' {
    { Get-MdeRoles -functionName 'Get-NotDefinedMdeFunction' -ErrorAction Stop } | Should -Throw "Invalid function name"
  }
}
