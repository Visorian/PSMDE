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
      $timestamp = [datetime]::Parse('2022-12-12T12:12:12')
      Get-MdeMachineByIp -ip $ip -timestamp $timestamp | Should -Be "https://api.securitycenter.microsoft.com/api/machines/findbyip(ip='$ip',timestamp=2022-12-12T12:12:12Z)"
    }
  }
}