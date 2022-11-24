BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Stop-MdeMachineFileExecution" {

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
      $sha1 = 'F8DAE85E2EEE4AA846D655670947E5C98B83B791'
      $body = ConvertTo-Json -Depth 5 -InputObject @{comment = $comment; Sha1 = $sha1 }
      $result = Stop-MdeMachineFileExecution -id $id -comment $comment -sha1 $sha1
      $result.uri | Should -Be "https://api.securitycenter.microsoft.com/api/machines/$id/StopAndQuarantineFile"
      $result.body | Should -Be $body
    }
  }
}