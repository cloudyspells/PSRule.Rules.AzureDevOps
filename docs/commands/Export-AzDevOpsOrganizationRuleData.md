# Export-AzDevOpsOrganizationRuleData

## SYNOPSIS
Export rule data for all projects in the DevOps organization

## SYNTAX

```
Export-AzDevOpsOrganizationRuleData [-OutputPath] <String> [<CommonParameters>]
```

## DESCRIPTION
Export rule data for all projects in the DevOps organization using Azure DevOps Rest API and this modules functions for analysis by PSRule

## EXAMPLES

### EXAMPLE 1
```
Export-AzDevOpsOrganizationRuleData -OutputPath $OutputPath
```

## PARAMETERS

### -OutputPath
Output path for JSON files

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
