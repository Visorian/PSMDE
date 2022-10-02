BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('private', 'PSMDE.psd1')
}

Describe 'Get-MdeAuthorizationHeader' {
  It 'Should have the PSMDE module loaded' {
    $module = Get-Module PSMDE
    $module | Should -Not -BeNullOrEmpty
  }

  It 'Should have access to internal functions' {
    InModuleScope PSMDE {
      $cmd = Get-Command Get-MdeAuthorizationHeader
      $cmd | Should -Not -BeNullOrEmpty
    }
  }

  It 'Should throw when authorization info is missing' {
    InModuleScope PSMDE {
      Mock Get-AesSessionSecret { }
      Mock Get-ParsedToken {
        return @{
          exp = "1234"
        }
      }
      Should -Not -Invoke Get-AesSessionSecret
      { Get-MdeAuthorizationHeader } | Should -Throw 'Authorization info missing. If you provided the token directly, you have to update it manually using Set-MdeAuthorizationInfo.'
    }
  }

  It 'Should call Get-AesSessionSecret when tokenCache is not empty and request a new token on expired tokenCache' {
    InModuleScope PSMDE {
      $script:tokenCache = 'not-empty'
      $script:appId = '00000000-0000-0000-0000-000000000000'
      $script:appSecret = 'not-empty'
      $script:tenantId = '00000000-0000-0000-0000-000000000000'
      Mock Get-AesSessionSecret { return 'token' }
      Mock New-AesSessionSecret { }
      Mock Invoke-RestMethod {
        return @{
          access_token = "access-token"
        }
      }
      Mock Get-ParsedToken {
        return @{
          exp = "1234"
        }
      }
      $result = Get-MdeAuthorizationHeader
      $result.Authorization | Should -Be "Bearer access-token"
      Should -Invoke Get-AesSessionSecret
      Should -Invoke Invoke-RestMethod
      Should -Invoke New-AesSessionSecret
    }
  }

  It 'Should return tokenCache, if not expired' {
    InModuleScope PSMDE {
      $script:tokenCache = 'not-empty'
      Mock Get-AesSessionSecret { return 'token' }
      Mock New-AesSessionSecret { }
      Mock Invoke-RestMethod { }
      Mock Get-ParsedToken {
        return @{
          exp = [DateTimeOffset]::Now.AddDays(1).ToUnixTimeSeconds()
        }
      }
      $result = Get-MdeAuthorizationHeader
      $result.Authorization | Should -Be "Bearer token"
      Should -Invoke Get-AesSessionSecret
      Should -Invoke Get-ParsedToken
      Should -Not -Invoke New-AesSessionSecret
      Should -Not -Invoke Invoke-RestMethod
    }
  }
}
