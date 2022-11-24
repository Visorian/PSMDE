BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Remove-MdeMachine" {

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
      Mock Invoke-RetryRequest { return @{uri = $uri; body = $body } }
      Mock Test-MdePermissions { return $true }
      $id = '12345'
      $comment = 'Comment'
      $body = ConvertTo-Json -Depth 5 -InputObject @{comment = $comment }
      $result = Remove-MdeMachine -id $id -comment $comment
      $result.uri | Should -Be "https://api.securitycenter.microsoft.com/api/machines/$id/offboard"
      $result.body | Should -Be $body
    }
  }
}