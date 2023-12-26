# Get-AzDevOpsRepositoryAcls

## SYNOPSIS
Get Azure DevOps repos ACLs

## SYNTAX

```
Get-AzDevOpsRepositoryAcls [-ProjectId] <String> [-RepositoryId] <String> [<CommonParameters>]
```

## DESCRIPTION
Get Azure DevOps repos ACLs using Azure DevOps Rest API

## EXAMPLES

### EXAMPLE 1
```
Get-AzDevOpsRepositoryAcls -ProjectId $ProjectId -RepositoryId $RepositoryId
```

## PARAMETERS

### -ProjectId
Project ID for Azure DevOps project

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
Repository ID for Azure DevOps

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
