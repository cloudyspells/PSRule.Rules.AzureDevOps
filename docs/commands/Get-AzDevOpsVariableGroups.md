# Get-AzDevOpsVariableGroups

## SYNOPSIS
Get all variable groups for a project from Azure DevOps.

## SYNTAX

```
Get-AzDevOpsVariableGroups [-Project] <String> [<CommonParameters>]
```

## DESCRIPTION
Get all variable groups for a project from Azure DevOps using the REST API.

## EXAMPLES

### EXAMPLE 1
```
Get-AzDevOpsVariableGroups -Project 'myproject'
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
