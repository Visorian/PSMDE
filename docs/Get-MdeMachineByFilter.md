---
external help file: PSMDE-help.xml
Module Name: PSMDE
online version: https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/get-machine-related-alerts?view=o365-worldwide
schema: 2.0.0
---

# Get-MdeMachineByFilter

## SYNOPSIS
Gets one or multiple machine objects by OData filter

## SYNTAX

```
Get-MdeMachineByFilter [-filter] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns all Defender for Endpoint machines that matches the filter.
For details, refer to the \[OData docs article\](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exposed-apis-odata-samples?view=o365-worldwide)

## EXAMPLES

### EXAMPLE 1
```
$machines = Get-MdeMachineByFilter -filter 'lastSeen gt 2018-08-01Z'
```

### EXAMPLE 2
```
$machines = Get-MdeMachineByFilter -filter "startswith(computerDnsName,'mymachine')"
```

### EXAMPLE 3
```
$machines = Get-MdeMachineByFilter -filter "healthStatus eq 'Active'"
```

## PARAMETERS

### -filter
{{ Fill filter Description }}

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
