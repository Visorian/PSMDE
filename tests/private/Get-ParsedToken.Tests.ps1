BeforeAll {
  . $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('tests', 'src')
}

Describe 'Get-ParsedToken' {
  BeforeEach {
    New-Variable -Name parsedToken -Value @{
      Issuer   = "Issuer"
      iat      = "1663061776"
      exp      = "1663061776"
      Username = "JavaInUse"
      Role     = "Admin"
      Roles    = "User.Read"
    } -Force
    New-Variable -Name token -Value 'eyJhbGciOiJIUzI1NiJ9.eyJSb2xlIjoiQWRtaW4iLCJJc3N1ZXIiOiJJc3N1ZXIiLCJVc2VybmFtZSI6IkphdmFJblVzZSIsIlJvbGVzIjoiVXNlci5SZWFkIiwiZXhwIjoxNjYzMDYxNzc2LCJpYXQiOjE2NjMwNjE3NzZ9.XHiUwAUwlJO6bmWghFp11xdTh7LfdZn1RuLOIK2RqQw' -Force
  }

  It 'Should have access to local variables' {
    $token | Should -Not -BeNullOrEmpty
    $parsedToken | Should -Not -BeNullOrEmpty
  }

  It 'Can decode token' {
    $parsed = Get-ParsedToken -token $token
    $parsed | Should -BeOfType System.Management.Automation.PSCustomObject
    $parsed.psobject.properties.name | ForEach-Object {
      Should -Be -ActualValue $parsed."$_" -ExpectedValue $parsedToken[$_]
    }
  }
}

