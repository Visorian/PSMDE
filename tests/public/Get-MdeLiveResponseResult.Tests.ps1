BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Get-MdeLiveResponseResult" {

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
      Mock Invoke-RetryRequest { return $uri }
      Mock Test-MdePermissions { return $true }
      $id = '12345'
      $index = 5
      Get-MdeLiveResponseResult -id $id | Should -Be "https://api.securitycenter.microsoft.com/api/machineactions/$id/GetLiveResponseResultDownloadLink(index=0)"
      Get-MdeLiveResponseResult -id $id -index $index | Should -Be "https://api.securitycenter.microsoft.com/api/machineactions/$id/GetLiveResponseResultDownloadLink(index=$index)"
    }
  }
}