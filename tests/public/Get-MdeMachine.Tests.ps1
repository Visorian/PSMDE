BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Get-MdeMachine" {

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

  It 'Should call Invoke-RetryRequest when id parameter is provided' {
    InModuleScope PSMDE {
      Mock Invoke-RetryRequest { }
      Mock Test-MdePermissions { return $true }
      Get-MdeMachine -id '123'
      Should -Invoke Invoke-RetryRequest
    }
  }

  It 'Should call Invoke-AzureRequest when no parameter is provided' {
    InModuleScope PSMDE {
      Mock Invoke-AzureRequest { }
      Mock Test-MdePermissions { return $true }
      Get-MdeMachine
      Should -Invoke Invoke-AzureRequest
    }
  }
}