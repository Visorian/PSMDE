BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Clear-MdeAuthorizationInfo" {

  It 'Should have the PSMDE module loaded' {
    $module = Get-Module PSMDE
    $module | Should -Not -BeNullOrEmpty
  }

  It 'Should have access to internal functions' {
    InModuleScope PSMDE {
      $cmd = Get-Command Clear-MdeAuthorizationInfo
      $cmd | Should -Not -BeNullOrEmpty
    }
  }

  It 'Should clear module variables' {
    InModuleScope PSMDE {
      $script:tenantId = 'abc'
      $script:appId = 'abc'
      $script:appSecret = 'abc'
      $script:tokenCache = 'abc'
      Clear-MdeAuthorizationInfo
      foreach ($variable in @('tenantId', 'appId', 'appSecret', 'tokenCache' )) {
        Get-Variable -Name $variable -ValueOnly | Should -BeNullOrEmpty
      }
    }
  }
}