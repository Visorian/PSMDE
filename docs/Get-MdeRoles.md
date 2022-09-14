---
external help file: PSMDE-help.xml
Module Name: PSMDE
online version: https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-discovered-vulnerabilities?view=o365-worldwide
schema: 2.0.0
---

# Get-MdeRoles

## SYNOPSIS
List roles for a given function.

## SYNTAX

```
Get-MdeRoles [-functionName] <String> [<CommonParameters>]
```

## DESCRIPTION
Lists required roles and current token roles for a specific function from this module.

## EXAMPLES

### EXAMPLE 1
```
Get-MdeRoles -functionName 'Get-MdeMachine'
```

## PARAMETERS

### -functionName
{{ Fill functionName Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Jan-Henrik Damaschke

## RELATED LINKS
