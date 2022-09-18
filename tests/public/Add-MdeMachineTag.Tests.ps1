BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Add-MdeMachineTag" {

  It 'Should have the PSMDE module loaded' {
    $module = Get-Module PSMDE
    $module | Should -Not -BeNullOrEmpty
  }

  It 'Should have access to internal functions' {
    InModuleScope PSMDE {
      $cmd = Get-Command Invoke-RetryRequest
      $cmd | Should -Not -BeNullOrEmpty
    }
  }

  It 'Should have mandatory parameters' {
    Get-Command Add-MdeMachineTag | Should -HaveParameter id -Mandatory
    Get-Command Add-MdeMachineTag | Should -HaveParameter tag -Mandatory
  }

  It 'Should call Invoke-RetryRequest when id parameter is provided' {
    InModuleScope PSMDE {
      Mock Test-MdePermissions { return $true }
      Mock Get-MdeAuthorizationInfo { return @{roles = @('Machine.ReadWrite.All', 'Machine.ReadWrite') } }
      Mock Invoke-RetryRequest { }
      Add-MdeMachineTag -id '123' -tag 'test'
      Should -Invoke Invoke-RetryRequest
    }
  }
}