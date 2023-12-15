<#
    .SYNOPSIS
    Get all release definitions in the current project.

    .DESCRIPTION
    Get all release definitions in the current project using the Azure DevOps REST API.

    .PARAMETER Project
    The name of the Azure DevOps project.

    .EXAMPLE
    Get-AzDevOpsReleaseDefinitions -Project 'myproject'
#>
Function Get-AzDevOpsReleaseDefinitions {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]$Project
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    Write-Verbose "URI: $uri"
    $header = $script:connection.GetHeader()
    $Organization = $script:connection.Organization
    Write-Verbose "Getting release definitions for project $Project"
    $uri = "https://vsrm.dev.azure.com/$Organization/$Project/_apis/release/definitions?api-version=7.2-preview.4"
    
    # try to get the release definitions, throw a descriptive error if it fails for authentication or other reasons
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        # If the response is not an object but a string, the authentication failed
        if ($response -is [string]) {
            throw "Authentication failed or project not found"
        }
    }
    catch {
        throw $_.Exception.Message
    }
    return @($response.value)
}
Export-ModuleMember -Function Get-AzDevOpsReleaseDefinitions
# End of function Get-AzDevOpsReleaseDefinitions

<#
    .SYNOPSIS
    Gets the release definition ACLs for a given release definition.

    .DESCRIPTION
    Gets the release definition ACLs for a given release definition using the Azure DevOps REST API.

    .PARAMETER ProjectId
    The ID of the Azure DevOps project.

    .PARAMETER ReleaseDefinitionId
    The ID of the release definition.

    .PARAMETER Folder
    The folder where the release definition is located.

    .EXAMPLE
    Get-AzDevOpsReleaseDefinitionAcls -ProjectId '12345678-1234-1234-1234-123456789012' -ReleaseDefinitionId 1 -Folder 'myfolder'
#>
Function Get-AzDevOpsReleaseDefinitionAcls {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]$ProjectId,

        [Parameter(Mandatory)]
        [int]$ReleaseDefinitionId,

        [Parameter()]
        [string]$Folder = ''
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $TokenType = $script:connection.TokenType
    $Organization = $script:connection.Organization
    # IF token type is ReadOnly, write a warning and exit the function returing null
    if ($TokenType -eq 'ReadOnly') {
        Write-Warning "The ReadOnly token type is not supported for this function"
        return $null
    } else {
        Write-Verbose "Getting release definition ACLs for release definition $ReleaseDefinitionId"
        if ($Folder -eq '') {
            $uri = "https://dev.azure.com/{0}/_apis/accesscontrollists/c788c23e-1b46-4162-8f5e-d7585343b5de?api-version=6.0&token={1}/{2}" -f $Organization, $ProjectId, $ReleaseDefinitionId
        }
        else {
            $uri = "https://dev.azure.com/{0}/_apis/accesscontrollists/c788c23e-1b46-4162-8f5e-d7585343b5de?api-version=6.0&token={1}/{2}/{3}" -f $Organization, $ProjectId, $Folder, $ReleaseDefinitionId
        }
        Write-Verbose "URI: $uri"
        $header = $script:connection.GetHeader()
        # try to get the release definition ACLs, throw a descriptive error if it fails for authentication or other reasons
        try {
            $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
            # If the response is not an object but a string, the authentication failed
            if ($response -is [string]) {
                throw "Authentication failed or project not found"
            }
        }
        catch {
            throw $_.Exception.Message
        }
        return $response.value
    }
}
Export-ModuleMember -Function Get-AzDevOpsReleaseDefinitionAcls
# End of function Get-AzDevOpsReleaseDefinitionAcls

<#
    .SYNOPSIS
    Get all release definitions in the current project and export them to a JSON file per definition.

    .DESCRIPTION
    Get all release definitions in the current project using the Azure DevOps REST API and export them to a JSON file per definition.

    .PARAMETER Project
    The name of the Azure DevOps project.

    .PARAMETER OutputPath
    The path to the directory where the JSON files will be exported.

    .EXAMPLE
    Export-AzDevOpsReleaseDefinitions -Project 'myproject' -OutputPath 'C:\temp'
#>
Function Export-AzDevOpsReleaseDefinitions {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter(Mandatory)]
        [string]$OutputPath
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $TokenType = $script:connection.TokenType
    $Organization = $script:connection.Organization
    $definitions = Get-AzDevOpsReleaseDefinitions -Project $Project
    foreach ($definition in $definitions) {
        if ($null -ne $definition.id) {
            $definitionId = $definition.id
            Write-Verbose "Getting release definition with id $definitionId"
            $uri = "https://vsrm.dev.azure.com/$Organization/$Project/_apis/release/definitions/$($definitionId)?api-version=7.2-preview.4"
            Write-Verbose "URI: $uri"
            $header = $script:connection.GetHeader()
            # try to get the release definition, throw a descriptive error if it fails for authentication or other reasons
            try {
                $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
            }
            catch {
                throw $_.Exception.Message
            }
            $definitionName = $response.name
            Write-Verbose "Exporting release definition $definitionName as file $definitionName.ado.rd.json"
            $definitionPath = Join-Path -Path $OutputPath -ChildPath "$definitionName.ado.rd.json"
            # Add an ObjectType of Azure.DevOps.Pipelines.Releases.Definition to the response
            $response | Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value 'Azure.DevOps.Pipelines.Releases.Definition'
            $response | Add-Member -MemberType NoteProperty -Name 'ObjectName' -Value ("{0}.{1}.{2}" -f $script:connection.Organization,$Project,$definitionName)
            # Get the project ID from the url in the response
            $projectId = $response.url.Split('/')[4]
            # Get the folder from the path in the response
            if ($response.path -eq '\') {
                $folder = ''
            }
            else {
                $folder = $response.path.replace('\','/')
            }
            # If the token type is not ReadOnly, get the release definitions ACLs
            if ($TokenType -ne 'ReadOnly') {
                # Get the release definition ACLs
                $acls = Get-AzDevOpsReleaseDefinitionAcls -ProjectId $projectId -ReleaseDefinitionId $definitionId -Folder $folder
                # Add the ACLs to the response
                $response | Add-Member -MemberType NoteProperty -Name 'Acls' -Value $acls
            } else {
                Write-Warning "The ReadOnly token type is not supported for ACL export"
            }
            $response | ConvertTo-Json -Depth 100 | Out-File -FilePath $definitionPath
        }
    }
}
Export-ModuleMember -Function Export-AzDevOpsReleaseDefinitions
