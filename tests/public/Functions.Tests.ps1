$functions = Get-ChildItem (Split-Path $PSCommandPath).Replace('tests', 'src') -Filter *.ps1
foreach ($function in $functions) {
  Describe "Verify $($function.BaseName)" -ForEach @{ Function = $function } {
    BeforeEach {
      New-Variable -Name 'exclusions' -Value @('Set-MdeAuthorizationInfo', 'Get-MdeAuthorizationInfo', 'Clear-MdeAuthorizationInfo', 'Get-MdeRoles', 'New-MdeServicePrincipal') -Force
    }

    It "Should have a test file" {
      Test-Path ($function.FullName.Replace('src', 'tests').Replace('.ps1', '.Tests.ps1')) | Should -Be $true
    }
  
    It "Should have inline help" {
      $function.FullName | Should -FileContentMatch '<#'
      $function.FullName | Should -FileContentMatch '#>'
    }
    
    It "Should have a SYNOPSIS help section" {
      $function.FullName | Should -FileContentMatch '.SYNOPSIS'
    }
    
    It "Should have a EXAMPLE help section" {
      $function.FullName | Should -FileContentMatch '.EXAMPLE'
    }

    It "Should have a ROLE help section with an array of hashtables" {
      if ($exclusions -notcontains $function.BaseName) {
        $function.FullName | Should -FileContentMatch '.ROLE'
        . $function.FullName
        $roleString = (Get-Help $function.BaseName).role
        $roleString | Should -Not -BeNullOrEmpty
        $roleString | Invoke-Expression | Should -BeOfType System.Collections.Hashtable
      }
    }

    It "Should use Test-MdePermissions to validate current permissions" {
      if ($exclusions -notcontains $function.BaseName) {
        $function.FullName | Should -FileContentMatch 'Test-MdePermissions'
      }
    }
    
    It "Should have advanced function parameters" {
      $function.FullName | Should -FileContentMatch 'function'
      $function.FullName | should -FileContentMatch 'cmdletbinding'
    }
  }
}
