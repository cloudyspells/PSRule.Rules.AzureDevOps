# Export-AzDevOpsVariableGroups

## SYNOPSIS
Export variable groups to JSON files.

## SYNTAX

```
Export-AzDevOpsVariableGroups [-Project] <String> [-OutputPath] <String> [<CommonParameters>]
```

## DESCRIPTION
Export Azure DevOps variable groups for a project to JSON files.

## EXAMPLES

### EXAMPLE 1
```
Export-AzDevOpsVariableGroups -Project 'myproject' -OutputPath 'C:\temp'
```

## PARAMETERS

### -Project
The name of the Azure DevOps project.

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
The path to export variable groups to.

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
All variable group files will have a suffix of .ado.vg.json.

## RELATED LINKS

[https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/variablegroups/get-variable-groups?view=azure-devops-rest-7.2](https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/variablegroups/get-variable-groups?view=azure-devops-rest-7.2)

