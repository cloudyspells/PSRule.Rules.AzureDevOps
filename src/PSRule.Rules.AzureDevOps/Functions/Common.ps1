# Function to create Azure DevOps Rest API header from PAT
# Usage: $header = Get-AzDevOpsHeader -PAT $PAT
# --------------------------------------------------

<#
    .SYNOPSIS
    Function to create Azure DevOps Rest API header from PAT

    .DESCRIPTION
    Function to create Azure DevOps Rest API header from PAT

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .EXAMPLE
    $header = Get-AzDevOpsHeader -PAT $PAT
#>
function Get-AzDevOpsHeader {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $PAT
    )
    $header = @{
        Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)"))
    }
    return $header
}
Export-ModuleMember -Function Get-AzDevOpsHeader
# End of Function Get-AzDevOpsHeader

<#
    .SYNOPSIS
    Get all Azure DevOps projects for an organization

    .DESCRIPTION
    Get all Azure DevOps projects for an organization using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsProjects -PAT $PAT -Organization $Organization
#>
function Get-AzDevOpsProjects {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $PAT,
        [Parameter()]
        [string]
        $Organization
    )
    $header = Get-AzDevOpsHeader -PAT $PAT
    Write-Verbose "Getting projects for organization $Organization"
    $uri = "https://dev.azure.com/$Organization/_apis/projects?api-version=6.0"
    Write-Verbose "URI: $uri"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
    }
    catch {
        Write-Warning "No projects found for organization $Organization"
        return @()
    }
    $projects = $response.value
    return $projects
}
Export-ModuleMember -Function Get-AzDevOpsProjects
# End of Function Get-AzDevOpsProjects
