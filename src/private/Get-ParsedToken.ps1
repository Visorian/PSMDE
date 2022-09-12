function Get-ParsedToken {
  # Source: https://www.michev.info/Blog/Post/2140/decode-jwt-access-and-id-tokens-via-powershell
  [CmdletBinding()]
  param (
    [string]
    $token
  )
  if (!$token.Contains(".") -or !$token.StartsWith("eyJ")) { Write-Error "Invalid token" -ErrorAction Stop }

  $tokenheader = $token.Split(".")[0].Replace('-', '+').Replace('_', '/')
  while ($tokenheader.Length % 4) { $tokenheader += "=" }
  $tokenPayload = $token.Split(".")[1].Replace('-', '+').Replace('_', '/')
  while ($tokenPayload.Length % 4) { $tokenPayload += "=" }
  $tokenByteArray = [System.Convert]::FromBase64String($tokenPayload)
  $tokenArray = [System.Text.Encoding]::ASCII.GetString($tokenByteArray)
  $tokobj = $tokenArray | ConvertFrom-Json
  return $tokobj
}