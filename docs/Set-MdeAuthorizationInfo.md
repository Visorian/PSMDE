---
external help file: PSMDE-help.xml
Module Name: PSMDE
online version: https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exposed-apis-create-app-webapp?view=o365-worldwide
schema: 2.0.0
---

# Set-MdeAuthorizationInfo

## SYNOPSIS
Set the authorization information that is used to get a valid MDE token.

## SYNTAX

```
Set-MdeAuthorizationInfo [-tenantId] <String> [-appId] <String> [-appSecret] <String> [-noTokenRefresh]
 [<CommonParameters>]
```

## DESCRIPTION
Set the authorization information that is used to get a valid MDE token.

## EXAMPLES

### EXAMPLE 1
```
Set-MdeAuthorizationInfo -tenantId '00000000-0000-0000-0000-000000000000' -appId '00000000-0000-0000-0000-000000000000' -appSecret 'APP_SECRET'
```

## PARAMETERS

### -appId
{{ Fill appId Description }}

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

### -appSecret
{{ Fill appSecret Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -noTokenRefresh
{{ Fill noTokenRefresh Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -tenantId
{{ Fill tenantId Description }}

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

[https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exposed-apis-create-app-webapp?view=o365-worldwide](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/exposed-apis-create-app-webapp?view=o365-worldwide)

