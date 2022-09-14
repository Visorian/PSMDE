BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Get-MdeMachineByFilter" {

  It 'Should have the PSMDE module loaded' {
    $module = Get-Module PSMDE
    $module | Should -Not -BeNullOrEmpty
  }

  It 'Should have access to internal functions' {
    InModuleScope PSMDE {
      $cmd = Get-Command Invoke-AzureRequest
      $cmd | Should -Not -BeNullOrEmpty
    }
  }

  It 'Should call Invoke-AzureRequest' {
    InModuleScope PSMDE {
      Mock Invoke-AzureRequest { }
      Mock Test-MdePermissions { return $true }
      Get-MdeMachineByFilter -filter "healthStatus eq 'Active'"
      Should -Invoke Invoke-AzureRequest
    }
  }
}