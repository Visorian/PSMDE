function New-AesSessionSecret {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $secret
  )
  $keyBytes = [Text.Encoding]::ASCII.GetBytes((Get-Process -PID $pid).ProcessorAffinity.ToString() + (Get-Process -PID $pid).Id.ToString())
  $encryptionKey = [System.Byte[]]::new(32)
  for ($i = 0; $i -lt $keyBytes.length; $i++) {
    $encryptionKey[$i] = $keyBytes[$i]
  }
  $rngCryptoServiceProvider = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
  $initializationVector = [System.Byte[]]::new(16)
  $rngCryptoServiceProvider.GetBytes($initializationVector)
  $aesCryptoServiceProvider = New-Object System.Security.Cryptography.AesCryptoServiceProvider
  $aesCryptoServiceProvider.Key = $encryptionKey
  $aesCryptoServiceProvider.IV = $initializationVector
  $secretBytes = [System.Text.Encoding]::UTF8.GetBytes($secret)
  $encryptor = $aesCryptoServiceProvider.CreateEncryptor()
  $encryptedBytes = $encryptor.TransformFinalBlock($secretBytes, 0, $secretBytes.Length)
  [byte[]] $data = $aesCryptoServiceProvider.IV + $encryptedBytes

  $aesCryptoServiceProvider.Dispose()
  $rngCryptoServiceProvider.Dispose()

  return [System.Convert]::ToBase64String($data)
}