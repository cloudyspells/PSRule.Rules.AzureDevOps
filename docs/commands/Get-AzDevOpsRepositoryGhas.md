# Get-AzDevOpsRepositoryGhas

## SYNOPSIS
Get GitHub Advanced Security (GHAS) data for a repository

## SYNTAX

```
Get-AzDevOpsRepositoryGhas [-ProjectId] <String> [-RepositoryId] <String> [<CommonParameters>]
```

## DESCRIPTION
Get GitHub Advanced Security (GHAS) data for a repository using Azure DevOps Rest API

## EXAMPLES

### EXAMPLE 1
```
Get-AzDevOpsRepositoryGhas -Project $Project -Repository $Repository
```

## PARAMETERS

### -ProjectId
Project ID for Azure DevOps

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

### -RepositoryId
{{ Fill RepositoryId Description }}

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

### System.Object
## NOTES

## RELATED LINKS
