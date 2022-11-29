BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Set-MdeAuthorizationInfo" {

  It 'Should have the PSMDE module loaded' {
    $module = Get-Module PSMDE
    $module | Should -Not -BeNullOrEmpty
  }

  It 'Should have access to internal functions' {
    InModuleScope PSMDE {
      $cmd = Get-Command Get-AesSessionSecret
      $cmd | Should -Not -BeNullOrEmpty
    }
  }

  It 'Should set module variables for service principal' {
    InModuleScope PSMDE {
      # Setup
      Mock Get-MdeAuthorizationHeader { }
      $script:tenantId = ''
      $script:appId = ''
      $script:appSecret = ''
      $ti = '123'
      $ai = '456'
      $as = '789'

      # Test
      Set-MdeAuthorizationInfo -tenantId $ti -appId $ai -appSecret $as
      Get-AesSessionSecret -cipherText $script:tenantId | Should -Be $ti
      Get-AesSessionSecret -cipherText $script:appId | Should -Be $ai
      Get-AesSessionSecret -cipherText $script:appSecret | Should -Be $as
      Should -Invoke Get-MdeAuthorizationHeader
    }
  }

  It 'Should set module variables for service principal from environment variables' {
    InModuleScope PSMDE {
      # Setup
      Mock Get-MdeAuthorizationHeader { }
      $script:tenantId = ''
      $script:appId = ''
      $script:appSecret = ''
      $ti = '123'
      $ai = '456'
      $as = '789'
      $env:MDE_APP_ID = $ai
      $env:MDE_APP_SECRET = $as
      $env:MDE_TENANT_ID = $ti

      # Test
      Set-MdeAuthorizationInfo -fromEnv
      Get-AesSessionSecret -cipherText $script:tenantId | Should -Be $ti
      Get-AesSessionSecret -cipherText $script:appId | Should -Be $ai
      Get-AesSessionSecret -cipherText $script:appSecret | Should -Be $as
      Should -Invoke Get-MdeAuthorizationHeader
    }
  }

  It 'Should set module variable for token' {
    InModuleScope PSMDE {
      # Setup
      Mock Get-MdeAuthorizationHeader { }
      $script:tokenCache = ''
      $tc = 'token'

      # Test
      Set-MdeAuthorizationInfo -token $tc
      Get-AesSessionSecret -cipherText $script:tokenCache | Should -Be $tc
      Should -Not -Invoke Get-MdeAuthorizationHeader
    }
  }
}