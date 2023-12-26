# Get-AzDevOpsReleaseDefinitionAcls

## SYNOPSIS
Gets the release definition ACLs for a given release definition.

## SYNTAX

```
Get-AzDevOpsReleaseDefinitionAcls [-ProjectId] <String> [-ReleaseDefinitionId] <Int32> [[-Folder] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets the release definition ACLs for a given release definition using the Azure DevOps REST API.

## EXAMPLES

### EXAMPLE 1
```
Get-AzDevOpsReleaseDefinitionAcls -ProjectId '12345678-1234-1234-1234-123456789012' -ReleaseDefinitionId 1 -Folder 'myfolder'
```

## PARAMETERS

### -ProjectId
The ID of the Azure DevOps project.

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

### -ReleaseDefinitionId
The ID of the release definition.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Folder
The folder where the release definition is located.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
