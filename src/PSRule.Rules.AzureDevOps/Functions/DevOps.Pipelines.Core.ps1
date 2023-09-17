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
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
    }
    catch {
        Write-Warning "No pipelines found for project $Project"
        return @()
    }
    # walk through all pipelines and get the pipeline details
    $pipelines = @()
    foreach ($pipeline in $response.value) {
        $uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/$($pipeline.id)?api-version=6.0-preview.1"
        $pipelineDetails = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        $pipelines += $pipelineDetails
    }
    return $pipelines
}
Export-ModuleMember -Function Get-AzDevOpsPipelines
# End of Function Get-AzDevOpsPipelines

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
    $pipelines = Get-AzDevOpsPipelines -PAT $PAT -Organization $Organization -Project $Project
    foreach ($pipeline in $pipelines) {
        # Add ObjectType Azure.DevOps.Pipeline to the pipeline object
        $pipeline | Add-Member -MemberType NoteProperty -Name ObjectType -Value "Azure.DevOps.Pipeline"
        $pipeline | ConvertTo-Json | Out-File "$OutputPath\$($pipeline.name).ado.pl.json"
    }
}
