# Get-AzDevOpsBranches

## SYNOPSIS
Get Azure DevOps branches for a repo

## SYNTAX

```
Get-AzDevOpsBranches [-Project] <String> [-Repository] <String> [<CommonParameters>]
```

## DESCRIPTION
Get Azure DevOps branches for a repo using Azure DevOps Rest API

## EXAMPLES

### EXAMPLE 1
```
Get-AzDevOpsBranches -Project $Project -Repository $Repository
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object[]
## NOTES

## RELATED LINKS
