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
            throw "Authentication failed or organization/project not found"	
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
            # if the response is not an object but a string, the authentication failed or the pipeline was not found
            if ($pipelineDetails -is [string]) {
                throw "Authentication failed or pipeline not found"	
            }
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
    }
}
Export-ModuleMember -Function Export-AzDevOpsPipelines