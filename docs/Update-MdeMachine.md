---
external help file: PSMDE-help.xml
Module Name: PSMDE
online version: https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/update-machine-method?view=o365-worldwide
schema: 2.0.0
---

# Update-MdeMachine

## SYNOPSIS
Updates properties of existing Machine.

## SYNTAX

```
Update-MdeMachine [-id] <String> [[-tags] <Array>] [[-priority] <String>] [<CommonParameters>]
```

## DESCRIPTION
Updates properties of existing Machine.

## EXAMPLES

### EXAMPLE 1
```
Update-MdeMachine -id '123' -tags @('tag-1', 'tag-2')
```

### EXAMPLE 2
```
Update-MdeMachine -id '123' -priority 'High'
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

### -priority
{{ Fill priority Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -tags
{{ Fill tags Description }}

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
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

[https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/update-machine-method?view=o365-worldwide](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/update-machine-method?view=o365-worldwide)

