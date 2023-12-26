# Export-AzDevOpsReposAndBranchPolicies

## SYNOPSIS
Get and export all Azure DevOps repos in a project with default, main and master branches and branch policies and export to JSON with 1 file per repo

## SYNTAX

```
Export-AzDevOpsReposAndBranchPolicies [-Project] <String> [-OutputPath] <String> [<CommonParameters>]
```

## DESCRIPTION
Get and export all Azure DevOps repos in a project with default, main and master branches and branch policies and export to JSON using Azure DevOps Rest API and this modules functions

## EXAMPLES

### EXAMPLE 1
```
Export-AzDevOpsReposAndBranchPolicies -Project $Project -OutputPath $OutputPath
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
Output path for JSON file

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
This function returns an empty object if no branch policy is found for the branch

## RELATED LINKS
