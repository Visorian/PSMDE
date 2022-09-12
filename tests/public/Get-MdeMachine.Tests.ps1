BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('\tests\public', '\src\PSMDE.psd1')
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
      Get-MdeMachine -id '123'
      Should -Invoke Invoke-RetryRequest
    }
  }

  It 'Should call Invoke-AzureRequest when id parameter is provided' {
    InModuleScope PSMDE {
      Mock Invoke-AzureRequest { }
      Get-MdeMachine
      Should -Invoke Invoke-AzureRequest
    }
  }
}