# Get-AzDevOpsBranchPolicy

## SYNOPSIS
Get Azure DevOps branch policy for a branch in a repo

## SYNTAX

```
Get-AzDevOpsBranchPolicy [-Project] <String> [-Repository] <String> [-Branch] <String> [<CommonParameters>]
```

## DESCRIPTION
Get Azure DevOps branch policy for a branch in a repo using Azure DevOps Rest API

## EXAMPLES

### EXAMPLE 1
```
Get-AzDevOpsBranchPolicy -Project $Project -Repository $Repository -Branch $Branch
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

### -Repository
Repository name for Azure DevOps

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

### -Branch
Branch name for Azure DevOps as a git ref.
Example: refs/heads/main

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
This function returns an empty object if no branch policy is found for the branch

## RELATED LINKS
