function Out-VerboseHashTable {
  [CmdletBinding()]
  param (
    [Parameter()]
    [hashtable]
    $hashtable
  )
  foreach ($key in $hashtable.Keys) { Write-Verbose "$key`: $($hashtable[$key])" }
}