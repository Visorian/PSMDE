BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Get-MdeAuthorizationInfo" {

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

  It 'Should call Get-AesSessionSecret and Get-ParsedToken when id parameter is provided' {
    InModuleScope PSMDE {
      $script:tokenCache = 'Test123'
      Mock Get-AesSessionSecret { }
      Mock Get-ParsedToken { }
      $result = Get-MdeAuthorizationInfo
      $result.Keys | Should -Contain 'tokenExpired'
      $result.Keys | Should -Contain 'roles'
      Should -Invoke Get-AesSessionSecret
      Should -Invoke Get-ParsedToken
    }
  }
}