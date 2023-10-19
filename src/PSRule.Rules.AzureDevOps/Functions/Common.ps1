﻿# Function to create Azure DevOps Rest API header from PAT
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
    [OutputType([System.Collections.Hashtable])]
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
    [OutputType([System.Object[]])]
    param (
        [Parameter(ParameterSetName = 'PAT')]
        [string]
        $PAT,
        
        [Parameter(ParameterSetName = 'PAT')]
        [ValidateSet('FullAccess', 'FineGrained', 'ReadOnly')]
        [string]
        $TokenType = 'FullAccess',

        [Parameter(ParameterSetName = 'PAT')]
        [string]
        $Organization
    )
    $header = Get-AzDevOpsHeader -PAT $PAT
    Write-Verbose "Getting projects for organization $Organization"
    $uri = "https://dev.azure.com/$Organization/_apis/projects?api-version=6.0"
    Write-Verbose "URI: $uri"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        # If the response is not an object but a string, the authentication failed
        if ($response -is [string]) {
            throw "Authentication failed or organization not found"
        }
    }
    catch {
        Write-Error "Failed to get projects from Azure DevOps"
        throw $_.Exception.Message
    }
    $projects = $response.value
    return @($projects)
}
Export-ModuleMember -Function Get-AzDevOpsProjects
# End of Function Get-AzDevOpsProjects
