function Get-AesSessionSecret {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $cipherText
  )
  $keyBytes = [Text.Encoding]::ASCII.GetBytes((Get-Process -PID $pid).ProcessorAffinity.ToString() + (Get-Process -PID $pid).Id.ToString())
  $encryptionKey = [System.Byte[]]::new(32)
  for ($i = 0; $i -lt $keyBytes.length; $i++) {
    $encryptionKey[$i] = $keyBytes[$i]
  }
  $encryptedBytes = [System.Convert]::FromBase64String($cipherText)
  $aesCryptoServiceProvider = New-Object System.Security.Cryptography.AesCryptoServiceProvider
  $aesCryptoServiceProvider.Key = $encryptionKey
  $aesCryptoServiceProvider.IV = $encryptedBytes[0..15]
  $decryptor = $aesCryptoServiceProvider.CreateDecryptor();
  $secretBytes = $decryptor.TransformFinalBlock($encryptedBytes, 16, $encryptedBytes.Length - 16)
  $decryptedSecret = [System.Text.Encoding]::UTF8.GetString($secretBytes)

  $aesCryptoServiceProvider.Dispose()

  return $decryptedSecret
}