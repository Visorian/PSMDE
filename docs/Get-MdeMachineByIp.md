---
external help file: PSMDE-help.xml
Module Name: PSMDE
online version: https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/find-machines-by-ip?view=o365-worldwide
schema: 2.0.0
---

# Get-MdeMachineByIp

## SYNOPSIS
Find Machines seen with the requested internal IP in the time range of 15 minutes prior and after a given timestamp.

## SYNTAX

```
Get-MdeMachineByIp [-ip] <String> [[-timestamp] <DateTime>] [<CommonParameters>]
```

## DESCRIPTION
Find Machines seen with the requested internal IP in the time range of 15 minutes prior and after a given timestamp.

## EXAMPLES

### EXAMPLE 1
```
Get-MdeMachineByIp -ip '192.168.1.1'
```

## PARAMETERS

### -ip
{{ Fill ip Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -timestamp
{{ Fill timestamp Description }}

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: [DateTime]::Now
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Jan-Henrik Damaschke

## RELATED LINKS

[https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/find-machines-by-ip?view=o365-worldwide](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/find-machines-by-ip?view=o365-worldwide)

