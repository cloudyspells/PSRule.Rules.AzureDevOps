# Export-AzDevOpsPipelinesSettings

## SYNOPSIS
Export the projects's pipelines settings from Azure DevOps to a JSON file

## SYNTAX

```
Export-AzDevOpsPipelinesSettings [-Project] <String> [-OutputPath] <String> [<CommonParameters>]
```

## DESCRIPTION
Export the projects's pipelines settings from Azure DevOps to a JSON file with .ado.pls.json extension

## EXAMPLES

### EXAMPLE 1
```
Export-AzDevOpsPipelinesSettings -Project $Project -OutputPath $OutputPath
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
Output path for JSON files

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

## RELATED LINKS
