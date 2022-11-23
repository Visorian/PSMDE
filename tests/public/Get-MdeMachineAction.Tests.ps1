BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Get-MdeMachineAction" {

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

  It 'Should correctly create the request uri' {
    InModuleScope PSMDE {
      Mock Invoke-AzureRequest { return $uri }
      Mock Invoke-RetryRequest { return $uri }
      Mock Test-MdePermissions { return $true }
      $id = 'CVE-2022-42075'
      $filter = "id+eq+'12345'"
      Get-MdeMachineAction | Should -Be "https://api.securitycenter.microsoft.com/api/machineactions"
      Get-MdeMachineAction -id $id | Should -Be "https://api.securitycenter.microsoft.com/api/machineactions/$id"
      Get-MdeMachineAction -filter $filter | Should -Be "https://api.securitycenter.microsoft.com/api/machineactions?`$filter=$filter"
    }
  }
}