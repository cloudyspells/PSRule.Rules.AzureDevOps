# Module: PSRule.Rules.AzureDevOps

<#
    .SYNOPSIS
    Get all Azure Pipelines definitions from Azure DevOps project

    .DESCRIPTION
    Get all Azure Pipelines definitions from Azure DevOps project using Azure DevOps Rest API

    .PARAMETER Project
    Project name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsPipelines -Project $Project
#>
function Get-AzDevOpsPipelines {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Project
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $header = $script:connection.GetHeader()
    $Organization = $script:connection.Organization
    
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines?api-version=6.0-preview.1"
    Write-Verbose "Getting pipelines from $uri"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        # if the response is not an object but a string, the authentication failed
        if ($response -is [string]) {
            throw "Authentication failed or project not found"
        }
    }
    catch {
        throw $_.Exception.Message
    }
    # walk through all pipelines and get the pipeline details
    $pipelines = @()
    foreach ($pipeline in $response.value) {
        Write-Verbose "Getting pipeline details for $($pipeline.id)"
        Write-Verbose "Getting pipeline details from $uri"
        $uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/$($pipeline.id)?api-version=6.0-preview.1"
        Write-Verbose "URI: $uri"
        $pipelineDetails = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        $pipelines += $pipelineDetails
    }
    return $pipelines
}
Export-ModuleMember -Function Get-AzDevOpsPipelines
# End of Function Get-AzDevOpsPipelines

<#
    .SYNOPSIS
    Get Azure DevOps pipeline ACLs

    .DESCRIPTION
    Get Azure DevOps pipeline ACLs using Azure DevOps Rest API

    .PARAMETER ProjectId
    Project ID for Azure DevOps

    .PARAMETER PipelineId
    Pipeline ID for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsPipelineAcls -ProjectId $ProjectId -PipelineId $PipelineId
#>
function Get-AzDevOpsPipelineAcls {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $ProjectId,
        [Parameter(Mandatory=$true)]
        [string]
        $PipelineId
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $TokenType = $script:connection.TokenType
    $Organization = $script:connection.Organization
    # If Token Type is ReadOnly, write a warning and exit the function returning null
    if ($TokenType -eq 'ReadOnly') {
        Write-Warning "Token Type is set to ReadOnly, no pipeline ACLs will be returned"
        return $null
    } else {
        $header = $script:connection.GetHeader()
        $uri = "https://dev.azure.com/$Organization/_apis/accesscontrollists/33344d9c-fc72-4d6f-aba5-fa317101a7e9?api-version=6.0&token=$($ProjectId)/$($PipelineId)"
        Write-Verbose "Getting pipeline ACLs from $uri"
        Write-Verbose "PROJECTID: $ProjectId"
        try {
            $response = (Invoke-RestMethod -Uri $uri -Method Get -Headers $header -ContentType "application/json") #| Where-Object { $_.token -eq "$($ProjectId)/$($PipelineId)" }
            # if the response is not an object but a string, the authentication failed
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
Export-ModuleMember -Function Get-AzDevOpsPipelineAcls
# End of Function Get-AzDevOpsPipelineAcls

# Begin of Function Get-AzDevOpsPipelineYaml
<#
    .SYNOPSIS
    Get YAML definition for Pipeline

    .DESCRIPTION
    Get YAML definition for Pipeline using Azure DevOps Rest API

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER PipelineId
    Pipeline Id for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsPipelineYaml -Project $Project -PipelineId $PipelineId
#>
function Get-AzDevOpsPipelineYaml {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Project,
        [Parameter(Mandatory=$true)]
        [string]
        $PipelineId
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $header = $script:connection.GetHeader()
    $Organization = $script:connection.Organization
    $yaml = ""
    # try to get parsed pipeline YAML definition, if that fails, retrieve the raw YAML definition via git
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/$($PipelineId)/runs?api-version=5.1-preview"
    Write-Verbose "Getting parsed YAML definition from $uri"
    try {
        $postBody = @{
            "previewRun" = $true
            "yamlOverride" = $null

        } | ConvertTo-Json -Depth 10

        $response = Invoke-RestMethod -Uri $uri -Method POST -Headers $header -Body $postBody -ContentType "application/json"
        $yaml = $response.finalYaml
    }
    catch {
        Write-Verbose "Getting the parsed YAML definition failed, trying to get the raw YAML definition"
        $uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/$($PipelineId)?api-version=7.1-preview.1"
        Write-Verbose "Getting pipeline details from $uri"
        try {
            $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        }
        catch {
            throw $_.Exception.Message
        }
        Write-Verbose "YAML definition located in repository id: $($response.configuration.repository.id)"
        $RepositoryId = $response.configuration.repository.id
        Write-Verbose "YAML definition path: $($response.configuration.path)"
        $YamlPath = $response.configuration.path
        $uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories/$RepositoryId/items?path=$YamlPath&api-version=6.0"
        Write-Verbose "Getting raw YAML definition from $uri"
        # Try to get the raw YAML definition from the repository
        try {
            $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        }
        catch {
            Write-Warning "Getting raw YAML definition from default branch failed, pipeline YAML definition will be empty"
            $response = $null
        }
        $yaml = $response
    }
    return $yaml
}
Export-ModuleMember -Function Get-AzDevOpsPipelineYaml
# End of Function Get-AzDevOpsPipelineYaml

# Begin of Function Export-AzDevOpsPipelineYaml
<#
    .SYNOPSIS
    Export YAML definition for Pipeline

    .DESCRIPTION
    Export YAML definition for Pipeline using Azure DevOps Rest API

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER PipelineId
    Pipeline Id for Azure DevOps

    .PARAMETER OutputPath
    Output path for YAML file

    .PARAMETER PassThru
    Pass the YAML definition to the pipeline object

    .EXAMPLE
    Export-AzDevOpsPipelineYaml -Project $Project -PipelineId $PipelineId -OutputPath $OutputPath
#>
function Export-AzDevOpsPipelineYaml {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Project,
        [Parameter(Mandatory)]
        [string]
        $PipelineId,
        [Parameter(Mandatory)]
        [string]
        $PipelineName,
        [Parameter(ParameterSetName = 'YamlFile')]
        [string]
        $OutputPath,
        [Parameter(ParameterSetName = 'PassThru')]
        [switch]
        $PassThru
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    
    Write-Verbose "Getting YAML definition for pipeline $PipelineId"
    $yaml = "ObjectType: Azure.DevOps.Pipelines.PipelineYaml`n"
    $yaml += "ObjectName: '$($script:connection.Organization).$Project.$PipelineName.Yaml'`n"
    $yamlTemp = Get-AzDevOpsPipelineYaml -Project $Project -PipelineId $PipelineId
    # Export the YAML definition to a file if it is not empty
    if ($null -eq $yamlTemp) {
        Write-Warning "YAML definition for pipeline $PipelineId is empty"
        return $null
    } else {
        $yaml += $yamlTemp}
    if ($PassThru) {
        Write-Output $yaml
    } else {
        Write-Verbose "Exporting YAML definition to $OutputPath\$PipelineName.yaml"
        $yaml | Out-File "$OutputPath\$PipelineName.yaml"
    }
}
Export-ModuleMember -Function Export-AzDevOpsPipelineYaml
# End of Function Export-AzDevOpsPipelineYaml

# Begin of Function Export-AzDevOpsPipelines
<#
    .SYNOPSIS
    Export all the pipelines to a separate JSON file per pipeline

    .DESCRIPTION
    Export all the pipelines to a separate JSON file per pipeline

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER OutputPath
    Output path for JSON files

    .PARAMETER PassThru
    Pass the pipeline object to the pipeline object instead of exporting to a file

    .EXAMPLE
    Export-AzDevOpsPipelines -Project $Project -OutputPath $OutputPath
#>
function Export-AzDevOpsPipelines {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Project,
        [Parameter(ParameterSetName = 'JsonFile')]
        [string]
        $OutputPath,
        [Parameter(ParameterSetName = 'PassThru')]
        [switch]
        $PassThru
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $TokenType = $script:connection.TokenType
    Write-Verbose "Getting pipelines from Azure DevOps"
    $pipelines = Get-AzDevOpsPipelines -Project $Project
    # Loop through all pipelines
    foreach ($pipeline in $pipelines) {
        # Add ObjectType Azure.DevOps.Pipeline to the pipeline object
        $pipeline | Add-Member -MemberType NoteProperty -Name ObjectType -Value "Azure.DevOps.Pipeline"
        $pipeline | Add-Member -MemberType NoteProperty -Name ObjectName -Value ("{0}.{1}.{2}" -f $script:connection.Organization,$Project,$pipeline.name)
        # Get the project ID from the pipeline object web.href property
        $ProjectId = $pipeline._links.web.href.Split('/')[4]

        # Add the pipeline ACLs to the pipeline object if the token type is not ReadOnly
        if ($TokenType -ne 'ReadOnly') {
            Write-Verbose "Getting pipeline ACLs for pipeline $($pipeline.name)"
            $pipeline | Add-Member -MemberType NoteProperty -Name Acls -Value (Get-AzDevOpsPipelineAcls -ProjectId $ProjectId -PipelineId $pipeline.id)
        } else {
            Write-Verbose "Token Type is set to ReadOnly, no pipeline ACLs will be returned"
        }
        If ($PassThru) {
            if ($pipeline.configuration.type -eq 'yaml' -and $pipeline.configuration.repository.type -eq 'azureReposGit') {
                Write-Verbose "Pipeline $($pipeline.name) is a YAML pipeline"
                Write-Verbose "Getting YAML definition for pipeline $($pipeline.name)"           
                Export-AzDevOpsPipelineYaml -Project $Project -PipelineId $pipeline.id -PipelineName $pipeline.name -PassThru
            }
            Write-Output $pipeline
        } else {
            Write-Verbose "Exporting pipeline $($pipeline.name) to JSON file"
            Write-Verbose "Exporting pipeline as JSON file to $OutputPath\$($pipeline.name).ado.pl.json"
            $pipeline | ConvertTo-Json -Depth 100 | Out-File "$OutputPath\$($pipeline.name).ado.pl.json"
            if ($pipeline.configuration.type -eq 'yaml' -and $pipeline.configuration.repository.type -eq 'azureReposGit') {
                Write-Verbose "Pipeline $($pipeline.name) is a YAML pipeline"
                Write-Verbose "Getting YAML definition for pipeline $($pipeline.name)"           
                
                Export-AzDevOpsPipelineYaml -Project $Project -PipelineId $pipeline.id -PipelineName $pipeline.name -OutputPath $OutputPath
            }
        }
    }
}
Export-ModuleMember -Function Export-AzDevOpsPipelines
# End of Function Export-AzDevOpsPipelines
