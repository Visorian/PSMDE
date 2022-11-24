BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Get-MdeMachineByTag" {

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
      $tag = 'monitored'
      $useStartsWithFilter = $true
      Get-MdeMachineByTag -tag $tag | Should -Be "https://api.securitycenter.microsoft.com/api/machines/findbytag?tag=$tag&useStartsWithFilter=false"
      Get-MdeMachineByTag -tag $tag -useStartsWithFilter $useStartsWithFilter | Should -Be "https://api.securitycenter.microsoft.com/api/machines/findbytag?tag=$tag&useStartsWithFilter=$useStartsWithFilter"
    }
  }
}