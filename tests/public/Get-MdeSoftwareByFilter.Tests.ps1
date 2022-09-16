BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Get-MdeSoftwareByFilter" {

  It 'Should have the PSMDE module loaded' {
    $module = Get-Module PSMDE
    $module | Should -Not -BeNullOrEmpty
  }

  It 'Should have access to internal functions' {
    InModuleScope PSMDE {
      $iar = Get-Command Invoke-AzureRequest
      $iar | Should -Not -BeNullOrEmpty
    }
  }

  It 'Should call Invoke-AzureRequest when a parameter is provided' {
    InModuleScope PSMDE {
      Mock Invoke-AzureRequest { }
      Mock Test-MdePermissions { return $true }
      Get-MdeSoftwareByFilter -filter '123'
      Should -Invoke Invoke-AzureRequest
    }
  }

  It 'Should correctly create the request uri' {
    InModuleScope PSMDE {
      Mock Invoke-AzureRequest { return $uri }
      Mock Test-MdePermissions { return $true }
      $filter1 = "vendor ne 'microsoft'"
      $filter2 = "id+eq+'microsoft-_-edge'&`$top=10"
      Get-MdeSoftwareByFilter -filter $filter1 | Should -Be "https://api.securitycenter.microsoft.com/api/Software?`$filter=$filter1"
      Get-MdeSoftwareByFilter -filter $filter2 | Should -Be "https://api.securitycenter.microsoft.com/api/Software?`$filter=$filter2"
    }
  }
}