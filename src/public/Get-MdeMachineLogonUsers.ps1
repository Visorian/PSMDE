<#
.SYNOPSIS
  Retrieves a collection of logged on users on a specific device.

.DESCRIPTION
  Retrieves a collection of logged on users on a specific device.

.NOTES
  Author: Jan-Henrik Damaschke

.PARAMETER id
  Optional. Specifies the id of the target MDE machine.

.OUTPUTS
  PSCustomObject. The Get-MdeMachine function returns a list of or a single PSCustomObject containing the parsed MDE machine logon user list.

.LINK
  https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-machine-log-on-users?view=o365-worldwide

.EXAMPLE
  Get-MdeMachineLogonUsers -id '123'

.ROLE
  @(@{permission = 'User.Read.All'; permissionType = 'Application'}, @{permission = 'User.Read.All'; permissionType = 'Delegated'})
#>

function Get-MdeMachineLogonUsers {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $id
  )
  Begin {
    if (-not (Test-MdePermissions -functionName $PSCmdlet.CommandRuntime)) {
      $requiredRoles = (Get-Help $PSCmdlet.CommandRuntime -Full).role | Invoke-Expression
      Throw "Missing required permission(s). Please check if one of these is in current token roles: $($requiredRoles.permission)"
    }
  }
  Process {
    return Invoke-AzureRequest -Uri "https://api.securitycenter.microsoft.com/api/machines/$id/logonusers"
  }
  End {}
}
# SIG # Begin signature block
# MIIVigYJKoZIhvcNAQcCoIIVezCCFXcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnHG0ikVudnoHWIXir22Nup8k
# HhegghHrMIIFbzCCBFegAwIBAgIQSPyTtGBVlI02p8mKidaUFjANBgkqhkiG9w0B
# AQwFADB7MQswCQYDVQQGEwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVy
# MRAwDgYDVQQHDAdTYWxmb3JkMRowGAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEh
# MB8GA1UEAwwYQUFBIENlcnRpZmljYXRlIFNlcnZpY2VzMB4XDTIxMDUyNTAwMDAw
# MFoXDTI4MTIzMTIzNTk1OVowVjELMAkGA1UEBhMCR0IxGDAWBgNVBAoTD1NlY3Rp
# Z28gTGltaXRlZDEtMCsGA1UEAxMkU2VjdGlnbyBQdWJsaWMgQ29kZSBTaWduaW5n
# IFJvb3QgUjQ2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAjeeUEiIE
# JHQu/xYjApKKtq42haxH1CORKz7cfeIxoFFvrISR41KKteKW3tCHYySJiv/vEpM7
# fbu2ir29BX8nm2tl06UMabG8STma8W1uquSggyfamg0rUOlLW7O4ZDakfko9qXGr
# YbNzszwLDO/bM1flvjQ345cbXf0fEj2CA3bm+z9m0pQxafptszSswXp43JJQ8mTH
# qi0Eq8Nq6uAvp6fcbtfo/9ohq0C/ue4NnsbZnpnvxt4fqQx2sycgoda6/YDnAdLv
# 64IplXCN/7sVz/7RDzaiLk8ykHRGa0c1E3cFM09jLrgt4b9lpwRrGNhx+swI8m2J
# mRCxrds+LOSqGLDGBwF1Z95t6WNjHjZ/aYm+qkU+blpfj6Fby50whjDoA7NAxg0P
# OM1nqFOI+rgwZfpvx+cdsYN0aT6sxGg7seZnM5q2COCABUhA7vaCZEao9XOwBpXy
# bGWfv1VbHJxXGsd4RnxwqpQbghesh+m2yQ6BHEDWFhcp/FycGCvqRfXvvdVnTyhe
# Be6QTHrnxvTQ/PrNPjJGEyA2igTqt6oHRpwNkzoJZplYXCmjuQymMDg80EY2NXyc
# uu7D1fkKdvp+BRtAypI16dV60bV/AK6pkKrFfwGcELEW/MxuGNxvYv6mUKe4e7id
# FT/+IAx1yCJaE5UZkADpGtXChvHjjuxf9OUCAwEAAaOCARIwggEOMB8GA1UdIwQY
# MBaAFKARCiM+lvEH7OKvKe+CpX/QMKS0MB0GA1UdDgQWBBQy65Ka/zWWSC8oQEJw
# IDaRXBeF5jAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zATBgNVHSUE
# DDAKBggrBgEFBQcDAzAbBgNVHSAEFDASMAYGBFUdIAAwCAYGZ4EMAQQBMEMGA1Ud
# HwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FBQUNlcnRpZmlj
# YXRlU2VydmljZXMuY3JsMDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYYaHR0
# cDovL29jc3AuY29tb2RvY2EuY29tMA0GCSqGSIb3DQEBDAUAA4IBAQASv6Hvi3Sa
# mES4aUa1qyQKDKSKZ7g6gb9Fin1SB6iNH04hhTmja14tIIa/ELiueTtTzbT72ES+
# BtlcY2fUQBaHRIZyKtYyFfUSg8L54V0RQGf2QidyxSPiAjgaTCDi2wH3zUZPJqJ8
# ZsBRNraJAlTH/Fj7bADu/pimLpWhDFMpH2/YGaZPnvesCepdgsaLr4CnvYFIUoQx
# 2jLsFeSmTD1sOXPUC4U5IOCFGmjhp0g4qdE2JXfBjRkWxYhMZn0vY86Y6GnfrDyo
# XZ3JHFuu2PMvdM+4fvbXg50RlmKarkUT2n/cR/vfw1Kf5gZV6Z2M8jpiUbzsJA8p
# 1FiAhORFe1rYMIIGGjCCBAKgAwIBAgIQYh1tDFIBnjuQeRUgiSEcCjANBgkqhkiG
# 9w0BAQwFADBWMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVk
# MS0wKwYDVQQDEyRTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgUm9vdCBSNDYw
# HhcNMjEwMzIyMDAwMDAwWhcNMzYwMzIxMjM1OTU5WjBUMQswCQYDVQQGEwJHQjEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSswKQYDVQQDEyJTZWN0aWdvIFB1Ymxp
# YyBDb2RlIFNpZ25pbmcgQ0EgUjM2MIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIB
# igKCAYEAmyudU/o1P45gBkNqwM/1f/bIU1MYyM7TbH78WAeVF3llMwsRHgBGRmxD
# eEDIArCS2VCoVk4Y/8j6stIkmYV5Gej4NgNjVQ4BYoDjGMwdjioXan1hlaGFt4Wk
# 9vT0k2oWJMJjL9G//N523hAm4jF4UjrW2pvv9+hdPX8tbbAfI3v0VdJiJPFy/7Xw
# iunD7mBxNtecM6ytIdUlh08T2z7mJEXZD9OWcJkZk5wDuf2q52PN43jc4T9OkoXZ
# 0arWZVeffvMr/iiIROSCzKoDmWABDRzV/UiQ5vqsaeFaqQdzFf4ed8peNWh1OaZX
# nYvZQgWx/SXiJDRSAolRzZEZquE6cbcH747FHncs/Kzcn0Ccv2jrOW+LPmnOyB+t
# AfiWu01TPhCr9VrkxsHC5qFNxaThTG5j4/Kc+ODD2dX/fmBECELcvzUHf9shoFvr
# n35XGf2RPaNTO2uSZ6n9otv7jElspkfK9qEATHZcodp+R4q2OIypxR//YEb3fkDn
# 3UayWW9bAgMBAAGjggFkMIIBYDAfBgNVHSMEGDAWgBQy65Ka/zWWSC8oQEJwIDaR
# XBeF5jAdBgNVHQ4EFgQUDyrLIIcouOxvSK4rVKYpqhekzQwwDgYDVR0PAQH/BAQD
# AgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEwYDVR0lBAwwCgYIKwYBBQUHAwMwGwYD
# VR0gBBQwEjAGBgRVHSAAMAgGBmeBDAEEATBLBgNVHR8ERDBCMECgPqA8hjpodHRw
# Oi8vY3JsLnNlY3RpZ28uY29tL1NlY3RpZ29QdWJsaWNDb2RlU2lnbmluZ1Jvb3RS
# NDYuY3JsMHsGCCsGAQUFBwEBBG8wbTBGBggrBgEFBQcwAoY6aHR0cDovL2NydC5z
# ZWN0aWdvLmNvbS9TZWN0aWdvUHVibGljQ29kZVNpZ25pbmdSb290UjQ2LnA3YzAj
# BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEM
# BQADggIBAAb/guF3YzZue6EVIJsT/wT+mHVEYcNWlXHRkT+FoetAQLHI1uBy/YXK
# ZDk8+Y1LoNqHrp22AKMGxQtgCivnDHFyAQ9GXTmlk7MjcgQbDCx6mn7yIawsppWk
# vfPkKaAQsiqaT9DnMWBHVNIabGqgQSGTrQWo43MOfsPynhbz2Hyxf5XWKZpRvr3d
# MapandPfYgoZ8iDL2OR3sYztgJrbG6VZ9DoTXFm1g0Rf97Aaen1l4c+w3DC+IkwF
# kvjFV3jS49ZSc4lShKK6BrPTJYs4NG1DGzmpToTnwoqZ8fAmi2XlZnuchC4NPSZa
# PATHvNIzt+z1PHo35D/f7j2pO1S8BCysQDHCbM5Mnomnq5aYcKCsdbh0czchOm8b
# kinLrYrKpii+Tk7pwL7TjRKLXkomm5D1Umds++pip8wH2cQpf93at3VDcOK4N7Ew
# oIJB0kak6pSzEu4I64U6gZs7tS/dGNSljf2OSSnRr7KWzq03zl8l75jy+hOds9TW
# SenLbjBQUGR96cFr6lEUfAIEHVC1L68Y1GGxx4/eRI82ut83axHMViw1+sVpbPxg
# 51Tbnio1lB93079WPFnYaOvfGAA0e0zcfF/M9gXr+korwQTh2Prqooq2bYNMvUoU
# KD85gnJ+t0smrWrb8dee2CvYZXD5laGtaAxOfy/VKNmwuWuAh9kcMIIGVjCCBL6g
# AwIBAgIQSLErKd7D+K4bkReO90aFWDANBgkqhkiG9w0BAQwFADBUMQswCQYDVQQG
# EwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSswKQYDVQQDEyJTZWN0aWdv
# IFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0EgUjM2MB4XDTIyMDkxNDAwMDAwMFoXDTI1
# MDkxMzIzNTk1OVowTzELMAkGA1UEBhMCREUxEDAOBgNVBAgMB0hhbWJ1cmcxFjAU
# BgNVBAoMDVZpc29yaWFuIEdtYkgxFjAUBgNVBAMMDVZpc29yaWFuIEdtYkgwggIi
# MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC/SsWhmbM7lO+pge5iLxuq3kXF
# 3xvbHU34E1wluLQOVC/A66AKKPo89E04zwAqqezN62flVYk9Xc+vFzNyy7I8wqq5
# vWojRnS7xW+QbFqJYxxHuGRiWEnt90p/wBrnq98Fl8JcmCKSDy/mUVAj+Lmq6WsU
# ph81PJMwC6T9POxk9/9k5I49Q8bBm5Yjx7yBTanHfdupCCFBgTFyJs9K4XLzva1I
# lCiMSYUxPRED0Dv8jVKdWnz3dbt00esUtubx5lD3YHdW6pYUR0hvJEi50G3sSqZ8
# Mebjts3+0PmEvHIR2aKvG/stx4jMngnBfwmeNbzWjwmqp4Qa4EGwv4Abs4hyK/kT
# erQua3IcXOgJqbblfxSoFDai14aCUGs2zxornoXhoYtjBj6XYgVS5eVME874hJLJ
# EZENiukta9r4IYOqnKglj+fwJrvEyx2INTELz99Ha074I8lG8ZJzNhuCqH6XgMUn
# 3EyOHMzbCrw1uDn0JDlhFX0sdaGXtopPgweIHbS87rcJc/tRSGhDG0YHqQWvxi9r
# Rb+v0L3KRYvtwih/VfpjQyFHFzcArDxKyrQ2SyGJ2ta0/Exl1dkYoTkVDm8R8f/2
# dG/VhTgvnDV1zW/SFRLwQAg/qmy6wpgK78338G+xCX47iauFtj2TAvw6sWB8jhwL
# xBvqvkP+r84HNB8KhQIDAQABo4IBpzCCAaMwHwYDVR0jBBgwFoAUDyrLIIcouOxv
# SK4rVKYpqhekzQwwHQYDVR0OBBYEFEHuYVgbSyoXa7Xei0crFprgrkXEMA4GA1Ud
# DwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMEoG
# A1UdIARDMEEwNQYMKwYBBAGyMQECAQMCMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8v
# c2VjdGlnby5jb20vQ1BTMAgGBmeBDAEEATBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
# Oi8vY3JsLnNlY3RpZ28uY29tL1NlY3RpZ29QdWJsaWNDb2RlU2lnbmluZ0NBUjM2
# LmNybDB5BggrBgEFBQcBAQRtMGswRAYIKwYBBQUHMAKGOGh0dHA6Ly9jcnQuc2Vj
# dGlnby5jb20vU2VjdGlnb1B1YmxpY0NvZGVTaWduaW5nQ0FSMzYuY3J0MCMGCCsG
# AQUFBzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTAcBgNVHREEFTATgRFpbmZv
# QHZpc29yaWFuLmNvbTANBgkqhkiG9w0BAQwFAAOCAYEASbJLCqUl82MPxtVDdBxd
# sOBCbYWxMvc4A9a/L+cuES3FYnBEa9jmA8o23+kvy2LZS3GeAU1AnNYkg2TAF+Oh
# fPDUviHUZDM/JgvCUF1ZmAvi6nLLBxvxfRxhGoUCkjaKIzDpPHZia6e/Jl9Xxthe
# GtCR9epTBuizMZTCTUvNPxY+Tm9L4EKHRsRBv8NkeuTKQpnGYfrHeKz/hVUeS4IS
# sTyv+xg7/nBITBSosfB79XDORaoNBxpqrSZLrpZV5OHIH2IGxRKKHyLVVCQAzriK
# +OV1EGBSmknqDarNbgtzU94iULYu15a1/PElzK7qB2i76FmLMMBVb9NVuXTfgMgT
# VzWfMs4mdsdOg7dcPxKpK2nViPbY3JQQVx8aKX+gJwWajuELP/JSE6nPYPSrwMLT
# xXRQ7AiScBTf6J3EeWq71AEUTSZ4/FImjbv0hDfnoSCr/6SRxc4it/kjXyJKXF1p
# VVbuEFsgyZpmxlSM3jSR9R02TrDR0q95oC/6eSwGxfwPMYIDCTCCAwUCAQEwaDBU
# MQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSswKQYDVQQD
# EyJTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0EgUjM2AhBIsSsp3sP4rhuR
# F473RoVYMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkG
# CSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEE
# AYI3AgEVMCMGCSqGSIb3DQEJBDEWBBS4EmDW3ZJb0ap8ms9gm8BSfMezJDANBgkq
# hkiG9w0BAQEFAASCAgCeOWse4F+z28Nyx4viN0nro7mgVpTjV/Q7sUEIcgd7ieia
# SsCijqF+cGuJ4lchv2x4WJt9r1uOgv5x03jCex4apWZunL4raK8wuwl+6w0BHA2/
# E0Tz9ElVSE2td+QTrK/XIg0EiInq48uCXv8bx4CBgMFyakAJM7oW4PgbrufobmPW
# H3kF7LYi0gyE4Ej2T1y7ta6mHp0Fp8hubtaoarmB4JeO1idGZED5dnnxQJqFhMYY
# JdvGojGLHaeIDubNC/hB2Gge3qxYPK+7kfyDddHsPCrfjEu7rnraZKHmaqvoOmo3
# x9lbFVITh4zNuugS/SITAb7WVuQI3VXxN67SnDh3x6Q1E3GSwPXFrRdZ8ceO1HV3
# kiY6zqiPBgm0YCCuOVI23kdKxJyNtmV7T9dQJpjjcvnyFuYTtlXNTKJW6dsSaVm/
# mRvbvqf9bpuLTt16TuPWU+cSJuWEFiAgvHLXNQKWYxBZVcNLJ7Z5tDZgV7kHf81j
# yMHJGUkqIbQMijs9HBgWguo/1JPyvjBQdAimffyYxbT4vlBwWKXssKES5JJoEajU
# s9zRhNX2/JqfQxv/I+XmMhqkphgWVTSxcs71RCMrMlCp04hDzprDL14CA0b7fHd0
# DjZQWNyu0WIvg1STlPxsyf/aMkeW7KL2iY96zcWpRCJ7n2C/GPK0QQbwQ14h9Q==
# SIG # End signature block
