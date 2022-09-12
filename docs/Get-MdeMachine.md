---
external help file: PSMDE-help.xml
Module Name: PSMDE
online version:
schema: 2.0.0
---

# Get-MdeMachine

## SYNOPSIS
Gets one or multiple machine objects

## SYNTAX

```
Get-MdeMachine [[-id] <String>] [<CommonParameters>]
```

## DESCRIPTION
If no parameters are specified, returns all Defender for Endpoint machines.
If an ID is specified, it returns a single machine object, if the ID is found, otherwise nothing.

## EXAMPLES

### EXAMPLE 1
```
$machines = Get-MdeMachine
```

### EXAMPLE 2
```
$machine = Get-MdeMachine -id '123'
```

## PARAMETERS

### -id
{{ Fill id Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
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
