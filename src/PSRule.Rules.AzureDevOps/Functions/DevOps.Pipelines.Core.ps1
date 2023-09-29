# Module: PSRule.Rules.AzureDevOps

<#
    .SYNOPSIS
    Get all Azure Pipelines definitions from Azure DevOps project

    .DESCRIPTION
    Get all Azure Pipelines definitions from Azure DevOps project using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsPipelines -PAT $PAT -Organization $Organization -Project $Project
#>
function Get-AzDevOpsPipelines {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $PAT,
        [Parameter()]
        [string]
        $Organization,
        [Parameter()]
        [string]
        $Project
    )
    $header = Get-AzDevOpsHeader -PAT $PAT

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
        try {
            $pipelineDetails = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        }
        catch {
            throw $_.Exception.Message
        }
        $pipelines += $pipelineDetails
    }
    return $pipelines
}
Export-ModuleMember -Function Get-AzDevOpsPipelines
# End of Function Get-AzDevOpsPipelines

# Begin of Function Get-AzDevOpsPipelineYaml
<#
    .SYNOPSIS
    Get YAML definition for Pipeline

    .DESCRIPTION
    Get YAML definition for Pipeline using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER PipelineId
    Pipeline Id for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsPipelineYaml -PAT $PAT -Organization $Organization -Project $Project -PipelineId $PipelineId
#>
function Get-AzDevOpsPipelineYaml {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $PAT,
        [Parameter()]
        [string]
        $Organization,
        [Parameter()]
        [string]
        $Project,
        [Parameter()]
        [string]
        $PipelineId
    )
    $header = Get-AzDevOpsHeader -PAT $PAT
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
        try {
            $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
            $yaml = $response
        }
        catch {
            throw $_.Exception.Message
        }
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

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER PipelineId
    Pipeline Id for Azure DevOps

    .PARAMETER OutputPath
    Output path for YAML file

    .EXAMPLE
    Export-AzDevOpsPipelineYaml -PAT $PAT -Organization $Organization -Project $Project -PipelineId $PipelineId -OutputPath $OutputPath
#>
function Export-AzDevOpsPipelineYaml {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $PAT,
        [Parameter()]
        [string]
        $Organization,
        [Parameter()]
        [string]
        $Project,
        [Parameter()]
        [string]
        $PipelineId,
        [Parameter()]
        [string]
        $PipelineName,
        [Parameter()]
        [string]
        $OutputPath
    )
    Write-Verbose "Getting YAML definition for pipeline $PipelineId"
    $yaml = "ObjectType: Azure.DevOps.Pipelines.PipelineYaml`n"
    $yaml += Get-AzDevOpsPipelineYaml -PAT $PAT -Organization $Organization -Project $Project -PipelineId $PipelineId
    Write-Verbose "Exporting YAML definition to $OutputPath\$PipelineName.yaml"
    $yaml | Out-File "$OutputPath\$PipelineName.yaml"
}
Export-ModuleMember -Function Export-AzDevOpsPipelineYaml
# End of Function Export-AzDevOpsPipelineYaml

# Begin of Function Export-AzDevOpsPipelines
<#
    .SYNOPSIS
    Export all the pipelines to a separate JSON file per pipeline

    .DESCRIPTION
    Export all the pipelines to a separate JSON file per pipeline

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER OutputPath
    Output path for JSON files

    .EXAMPLE
    Export-AzDevOpsPipelines -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
#>
function Export-AzDevOpsPipelines {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $PAT,
        [Parameter()]
        [string]
        $Organization,
        [Parameter()]
        [string]
        $Project,
        [Parameter()]
        [string]
        $OutputPath
    )
    Write-Verbose "Getting pipelines from Azure DevOps"
    $pipelines = Get-AzDevOpsPipelines -PAT $PAT -Organization $Organization -Project $Project
    foreach ($pipeline in $pipelines) {
        # Add ObjectType Azure.DevOps.Pipeline to the pipeline object
        $pipeline | Add-Member -MemberType NoteProperty -Name ObjectType -Value "Azure.DevOps.Pipeline"
        Write-Verbose "Exporting pipeline $($pipeline.name) to JSON file"
        Write-Verbose "Exporting pipeline as JSON file to $OutputPath\$($pipeline.name).ado.pl.json"
        $pipeline | ConvertTo-Json -Depth 100 | Out-File "$OutputPath\$($pipeline.name).ado.pl.json"
        if ($pipeline.configuration.type -eq 'yaml' -and $pipeline.configuration.repository.type -eq 'azureReposGit') {
            Write-Verbose "Pipeline $($pipeline.name) is a YAML pipeline"
            Write-Verbose "Getting YAML definition for pipeline $($pipeline.name)"
            $yaml = "ObjectType: Azure.DevOps.Pipelines.PipelineYaml`n"
            $yaml += "PipelineName: $($pipeline.name)`n"
            $yaml += Get-AzDevOpsPipelineYaml -PAT $PAT -Organization $Organization -Project $Project -PipelineId $pipeline.id
            Write-Verbose "Exporting YAML definition to $OutputPath\$($pipeline.name).yaml"
            $yaml | Out-File "$OutputPath\$($pipeline.name).yaml"
            Write-Verbose "Exporting pipeline YAML definition to $OutputPath\$($pipeline.name).yaml"
            Export-AzDevOpsPipelineYaml -PAT $PAT -Organization $Organization -Project $Project -PipelineId $pipeline.id -PipelineName $pipeline.name -OutputPath $OutputPath
        }
        
    }
}
Export-ModuleMember -Function Export-AzDevOpsPipelines
# End of Function Export-AzDevOpsPipelines