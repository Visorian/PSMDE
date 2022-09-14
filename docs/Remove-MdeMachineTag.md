---
external help file: PSMDE-help.xml
Module Name: PSMDE
online version: https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-machines-by-vulnerability?view=o365-worldwide
schema: 2.0.0
---

# Remove-MdeMachineTag

## SYNOPSIS
Removes tag to a specific Machine.

## SYNTAX

```
Remove-MdeMachineTag [-id] <String> [-tag] <String> [<CommonParameters>]
```

## DESCRIPTION
Removes tag to a specific Machine.

## EXAMPLES

### EXAMPLE 1
```
Remove-MdeMachineTag -id '123' -tag 'Tag-1'
```

## PARAMETERS

### -id
{{ Fill id Description }}

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

### -tag
{{ Fill tag Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
