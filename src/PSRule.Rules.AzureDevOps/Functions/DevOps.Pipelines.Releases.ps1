<#
    .SYNOPSIS
    Get all release definitions in the current project.

    .DESCRIPTION
    Get all release definitions in the current project using the Azure DevOps REST API.

    .PARAMETER Project
    The name of the Azure DevOps project.

    .PARAMETER Organization
    The name of the Azure DevOps organization.

    .PARAMETER PAT
    A personal access token (PAT) used to authenticate with Azure DevOps.

    .EXAMPLE
    Get-AzDevOpsReleaseDefinitions -Organization 'contoso' -Project 'myproject' -PAT $MyPAT
#>
Function Get-AzDevOpsReleaseDefinitions {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$PAT
    )
    Write-Verbose "Getting release definitions for project $Project"
    $uri = "https://vsrm.dev.azure.com/$Organization/$Project/_apis/release/definitions?api-version=7.2-preview.4"
    Write-Verbose "URI: $uri"
    $header = Get-AzDevOpsHeader -PAT $PAT
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

    .PARAMETER Organization
    The name of the Azure DevOps organization.

    .PARAMETER PAT
    A personal access token (PAT) used to authenticate with Azure DevOps.

    .PARAMETER Folder
    The folder where the release definition is located.

    .EXAMPLE
    Get-AzDevOpsReleaseDefinitionAcls -Organization 'contoso' -ProjectId '12345678-1234-1234-1234-123456789012' -ReleaseDefinitionId 1 -PAT $MyPAT -Folder 'myfolder'
#>
Function Get-AzDevOpsReleaseDefinitionAcls {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$ProjectId,

        [Parameter(Mandatory = $true)]
        [int]$ReleaseDefinitionId,

        [Parameter(Mandatory = $true)]
        [string]$PAT,

        [Parameter(Mandatory = $false)]
        [string]$Folder = ''
    )
    Write-Verbose "Getting release definition ACLs for release definition $ReleaseDefinitionId"
    if ($Folder -eq '') {
        $uri = "https://dev.azure.com/{0}/_apis/accesscontrollists/c788c23e-1b46-4162-8f5e-d7585343b5de?api-version=6.0&token={1}/{2}" -f $Organization, $ProjectId, $ReleaseDefinitionId
    }
    else {
        $uri = "https://dev.azure.com/{0}/_apis/accesscontrollists/c788c23e-1b46-4162-8f5e-d7585343b5de?api-version=6.0&token={1}/{2}/{3}" -f $Organization, $ProjectId, $Folder, $ReleaseDefinitionId
    }
    Write-Verbose "URI: $uri"
    $header = Get-AzDevOpsHeader -PAT $PAT
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
Export-ModuleMember -Function Get-AzDevOpsReleaseDefinitionAcls
# End of function Get-AzDevOpsReleaseDefinitionAcls

<#
    .SYNOPSIS
    Get all release definitions in the current project and export them to a JSON file per definition.

    .DESCRIPTION
    Get all release definitions in the current project using the Azure DevOps REST API and export them to a JSON file per definition.

    .PARAMETER Project
    The name of the Azure DevOps project.

    .PARAMETER Organization
    The name of the Azure DevOps organization.

    .PARAMETER PAT
    A personal access token (PAT) used to authenticate with Azure DevOps.

    .PARAMETER OutputPath
    The path to the directory where the JSON files will be exported.

    .EXAMPLE
    Export-AzDevOpsReleaseDefinitions -Organization 'contoso' -Project 'myproject' -PAT $MyPAT -OutputPath 'C:\temp'
#>
Function Export-AzDevOpsReleaseDefinitions {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$PAT,

        [Parameter(Mandatory = $true)]
        [string]$OutputPath
    )
    $definitions = Get-AzDevOpsReleaseDefinitions -Organization $Organization -Project $Project -PAT $PAT
    foreach ($definition in $definitions) {
        if ($null -ne $definition.id) {
            $definitionId = $definition.id
            Write-Verbose "Getting release definition with id $definitionId"
            $uri = "https://vsrm.dev.azure.com/$Organization/$Project/_apis/release/definitions/$($definitionId)?api-version=7.2-preview.4"
            Write-Verbose "URI: $uri"
            $header = Get-AzDevOpsHeader -PAT $PAT
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
            # Get the project ID from the url in the response
            $projectId = $response.url.Split('/')[4]
            # Get the folder from the path in the response
            if ($response.path -eq '\') {
                $folder = ''
            }
            else {
                $folder = $response.path.replace('\','/')
            }
            # Get the release definition ACLs
            $acls = Get-AzDevOpsReleaseDefinitionAcls -Organization $Organization -ProjectId $projectId -ReleaseDefinitionId $definitionId -PAT $PAT -Folder $folder
            # Add the ACLs to the response
            $response | Add-Member -MemberType NoteProperty -Name 'Acls' -Value $acls
            $response | ConvertTo-Json -Depth 100 | Out-File -FilePath $definitionPath
        }
    }
}
Export-ModuleMember -Function Export-AzDevOpsReleaseDefinitions
