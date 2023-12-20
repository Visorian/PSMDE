BeforeAll {
  Remove-Module PSMDE -Force -ErrorAction SilentlyContinue
  Import-Module (Split-Path $PSCommandPath).replace('tests', 'src').Replace('public', 'PSMDE.psd1')
}

Describe "Get-MdeMachineByIp" {

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
      $ip = '192.168.1.1'
      $tooOldTimestamp = [datetime]::Parse('2022-12-12T12:12:12')
      $timestamp = ([DateTime]::now).AddDays(-15)
      { Get-MdeMachineByIp -ip $ip -timestamp $tooOldTimestamp } | Should -Throw
      Get-MdeMachineByIp -ip $ip -timestamp $timestamp | Should -Be "https://api.securitycenter.microsoft.com/api/machines/findbyip(ip='$ip',timestamp=$($timestamp.toString('yyyy-MM-ddThh:mm:ssZ')))"
    }
  }
}