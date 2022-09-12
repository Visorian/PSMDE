BeforeAll {
  . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('tests', 'src').Replace('AesSessionSecret', 'Get-AesSessionSecret')
  . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('tests', 'src').Replace('AesSessionSecret', 'New-AesSessionSecret')
}

Describe 'AesSessionSecrets' {
  BeforeEach {
    New-Variable -Scope Script -Name encryptedSecret -Value $null -Force
    New-Variable -Scope Script -Name secret -Value 'Test123' -Force
  }

  It 'Can encrypt a secret' {
    $encryptedSecret = New-AesSessionSecret -secret $secret
    $encryptedSecret | Should -Not -BeNullOrEmpty
  }

  It 'Can encrypt and decrypt a secret' {
    $encryptedSecret = New-AesSessionSecret -secret $secret
    $encryptedSecret | Should -Not -BeNullOrEmpty
    $unencryptedSecret = Get-AesSessionSecret -cipherText $encryptedSecret
    $unencryptedSecret | Should -Be $secret
  }
}