# Export-AzDevOpsServiceConnections

## SYNOPSIS
Export all Azure Resource Manager service connections from Azure DevOps project with checks as nested objects

## SYNTAX

```
Export-AzDevOpsServiceConnections [-Project] <String> [-OutputPath] <String> [<CommonParameters>]
```

## DESCRIPTION
Export all Azure Resource Manager service connections from Azure DevOps project with checks as nested objects using Azure DevOps Rest API

## EXAMPLES

### EXAMPLE 1
```
Export-AzDevOpsServiceConnections -Project $Project -OutputPath $OutputPath
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
Output path for JSON files

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

## NOTES

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/azure/devops/approvalsandchecks/check-configurations/list?view=azure-devops-rest-7.2&tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/azure/devops/approvalsandchecks/check-configurations/list?view=azure-devops-rest-7.2&tabs=HTTP)

