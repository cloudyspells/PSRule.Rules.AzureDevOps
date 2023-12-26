# Get-AzDevOpsEnvironmentChecks

## SYNOPSIS
Get all checks for an Azure Pipelines environment

## SYNTAX

```
Get-AzDevOpsEnvironmentChecks [-Project] <String> [-Environment] <String> [<CommonParameters>]
```

## DESCRIPTION
Get all checks for an Azure Pipelines environment using Azure DevOps Rest API

## EXAMPLES

### EXAMPLE 1
```
Get-AzDevOpsEnvironmentChecks -Project $Project -Environment $Environment
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

### -Environment
Environment name for Azure DevOps

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
Returns an empty array if no checks are found

## RELATED LINKS

[https://learn.microsoft.com/en-us/rest/api/azure/devops/approvalsandchecks/check-configurations/list?view=azure-devops-rest-7.2&tabs=HTTP](https://learn.microsoft.com/en-us/rest/api/azure/devops/approvalsandchecks/check-configurations/list?view=azure-devops-rest-7.2&tabs=HTTP)

