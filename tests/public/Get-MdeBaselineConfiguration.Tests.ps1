BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Get-MdeBaselineConfiguration" {

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
      Mock Test-MdePermissions { return $true }
      $filter = "vendor+eq+'microsoft'"
      Get-MdeBaselineConfiguration | Should -Be "https://api.securitycenter.microsoft.com/api/baselineConfigurations"
      Get-MdeBaselineConfiguration -filter $filter | Should -Be "https://api.securitycenter.microsoft.com/api/baselineConfigurations?`$filter=$filter"
    }
  }
}