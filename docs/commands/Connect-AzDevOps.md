# Connect-AzDevOps

## SYNOPSIS
Connect to Azure DevOps for a session using a Service Principal, Managed Identity or Personal Access Token (PAT)

## SYNTAX

### PAT
```
Connect-AzDevOps -Organization <String> [-PAT <String>] [-AuthType <String>] [-TokenType <String>]
 [<CommonParameters>]
```

### ServicePrincipal
```
Connect-AzDevOps -Organization <String> -ClientId <String> -ClientSecret <String> -TenantId <String>
 [-AuthType <String>] [-TokenType <String>] [<CommonParameters>]
```

## DESCRIPTION
Connect to Azure DevOps for a session using a Service Principal, Managed Identity or Personal Access Token (PAT)

## EXAMPLES

### EXAMPLE 1
```
Connect-AzDevOps -Organization $Organization -PAT $PAT
```

### EXAMPLE 2
```
Connect-AzDevOps -Organization $Organization -ClientId $ClientId -ClientSecret $ClientSecret -TenantId $TenantId -AuthType ServicePrincipal
```

### EXAMPLE 3
```
Connect-AzDevOps -Organization $Organization -AuthType ManagedIdentity
```

### EXAMPLE 4
```
Connect-AzDevOps -Organization $Organization -PAT $PAT -AuthType PAT
```

## PARAMETERS

### -Organization
Organization name for Azure DevOps

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PAT
Personal Access Token (PAT) for Azure DevOps

```yaml
Type: String
Parameter Sets: PAT
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
Client ID for Service Principal

```yaml
Type: String
Parameter Sets: ServicePrincipal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
Client Secret for Service Principal

```yaml
Type: String
Parameter Sets: ServicePrincipal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantId
Tenant ID for Service Principal

```yaml
Type: String
Parameter Sets: ServicePrincipal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthType
Authentication type for Azure DevOps (PAT, ServicePrincipal, ManagedIdentity)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: PAT
Accept pipeline input: False
Accept wildcard characters: False
```

### -TokenType
Token type for Azure DevOps (FullAccess, FineGrained, ReadOnly)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: FullAccess
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### AzureDevOpsConnection
## NOTES

## RELATED LINKS
