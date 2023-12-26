# Export-AzDevOpsReleaseDefinitions

## SYNOPSIS
Get all release definitions in the current project and export them to a JSON file per definition.

## SYNTAX

```
Export-AzDevOpsReleaseDefinitions [-Project] <String> [-OutputPath] <String> [<CommonParameters>]
```

## DESCRIPTION
Get all release definitions in the current project using the Azure DevOps REST API and export them to a JSON file per definition.

## EXAMPLES

### EXAMPLE 1
```
Export-AzDevOpsReleaseDefinitions -Project 'myproject' -OutputPath 'C:\temp'
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
The path to the directory where the JSON files will be exported.

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
