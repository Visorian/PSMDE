BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Get-MdeSoftware" {

  It 'Should have the PSMDE module loaded' {
    $module = Get-Module PSMDE
    $module | Should -Not -BeNullOrEmpty
  }

  It 'Should have access to internal functions' {
    InModuleScope PSMDE {
      $irr = Get-Command Invoke-RetryRequest
      $irr | Should -Not -BeNullOrEmpty
      $iar = Get-Command Invoke-AzureRequest
      $iar | Should -Not -BeNullOrEmpty
    }
  }

  It 'Should call Invoke-RetryRequest when any parameter is provided' {
    InModuleScope PSMDE {
      Mock Invoke-RetryRequest { }
      Mock Test-MdePermissions { return $true }
      Get-MdeSoftware -id '123'
      Should -Invoke Invoke-RetryRequest
    }
  }

  It 'Should call Invoke-AzureRequest when no parameter is provided' {
    InModuleScope PSMDE {
      Mock Invoke-AzureRequest { }
      Mock Test-MdePermissions { return $true }
      Get-MdeSoftware
      Should -Invoke Invoke-AzureRequest
    }
  }

  It 'Should correctly create the request uri' {
    InModuleScope PSMDE {
      Mock Invoke-RetryRequest { return $uri }
      Mock Test-MdePermissions { return $true }
      Get-MdeSoftware -id '123' -name 'softwareName' | Should -Be "https://api.securitycenter.microsoft.com/api/machines?`$filter=id eq '123' and name eq 'softwareName'"
      Get-MdeSoftware -id '123' -vendor 'vendorName' | Should -Be "https://api.securitycenter.microsoft.com/api/machines?`$filter=id eq '123' and vendor eq 'vendorName'"
    }
  }
}