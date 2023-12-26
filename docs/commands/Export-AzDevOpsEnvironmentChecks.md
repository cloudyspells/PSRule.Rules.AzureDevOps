# Export-AzDevOpsEnvironmentChecks

## SYNOPSIS
Export all Azure Pipelines environments to JSON files with their checks as nested objects

## SYNTAX

```
Export-AzDevOpsEnvironmentChecks [-Project] <String> [-OutputPath] <String> [<CommonParameters>]
```

## DESCRIPTION
Export all Azure Pipelines environments to JSON files with their checks as nested objects using Azure DevOps Rest API

## EXAMPLES

### EXAMPLE 1
```
Export-AzDevOpsEnvironmentChecks -Project $Project
```

## PARAMETERS

### -Project
Project name for Azure DevOps

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
{{ Fill OutputPath Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object[]
## NOTES

## RELATED LINKS
