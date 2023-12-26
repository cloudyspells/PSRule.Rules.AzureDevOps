# Test-AzDevOpsFileExists

## SYNOPSIS
Check the existance of a file in an Azure DevOps repo

## SYNTAX

```
Test-AzDevOpsFileExists [-Project] <String> [-Repository] <String> [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Check the existance of a file in an Azure DevOps repo using Azure DevOps Rest API

## EXAMPLES

### EXAMPLE 1
```
Test-AzDevOpsFileExists -Project $Project -Repository $Repository -Path $Path
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

### -Path
Path to file in repo

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

### System.Boolean
## NOTES
This function return $true if the file exists and $false if it does not

## RELATED LINKS
