---
external help file: PSMDE-help.xml
Module Name: PSMDE
online version: https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/find-machines-by-tag?view=o365-worldwide
schema: 2.0.0
---

# Get-MdeMachineByTag

## SYNOPSIS
Find Machines by Tag.

## SYNTAX

```
Get-MdeMachineByTag [-tag] <String> [[-useStartsWithFilter] <Boolean>] [<CommonParameters>]
```

## DESCRIPTION
Find Machines by Tag.
The optional parameter useStartsWithFilter sets the matching to lazy matching the start of the machine name.
E.g.
-tag 'tag-' will match 'tag-1', 'tag-123', etc..

## EXAMPLES

### EXAMPLE 1
```
Get-MdeMachineByTag -tag 'tag-01'
```

## PARAMETERS

### -tag
{{ Fill tag Description }}

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

### -useStartsWithFilter
{{ Fill useStartsWithFilter Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
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

[https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/find-machines-by-tag?view=o365-worldwide](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/find-machines-by-tag?view=o365-worldwide)

