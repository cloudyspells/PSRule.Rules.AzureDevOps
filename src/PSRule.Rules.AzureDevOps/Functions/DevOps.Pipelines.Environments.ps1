﻿<#
    .SYNOPSIS
    Get all Azure Pipelines environments from Azure DevOps project

    .DESCRIPTION
    Get all Azure Pipelines environments named from Azure DevOps project using Azure DevOps Rest API

    .PARAMETER TokenType
    Token Type for Azure DevOps, can be FullAccess, FineGrained or ReadOnly

    .PARAMETER Project
    Project name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsEnvironments -Project $Project
#>
function Get-AzDevOpsEnvironments {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('FullAccess', 'FineGrained', 'ReadOnly')]
        [string]
        $TokenType = 'FullAccess',
        [Parameter(Mandatory)]
        [string]
        $Project
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    # If token type is ReadOnly, write a warning and exit the function returing null
    if($TokenType -eq 'ReadOnly') {
        Write-Warning "Token type ReadOnly does not have access to Azure DevOps Pipelines Environments"
        return $null
    } else {
        $header = $script:connection.GetHeader()
        $Organization = $script:connection.Organization

        Write-Verbose "Getting environments for project $Project"
        $uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/environments?api-version=6.0-preview.1"
        Write-Verbose "URI: $uri"
        try {
            $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
            # If the response is a string and not an object, throw an exception for authentication failure or project not found
            if ($response -is [string]) {
                throw "Authentication failed or project not found"
            }
        }
        catch {
            throw $_.Exception.Message
        }
        $environments = $response.value
        return $environments
    }
}
Export-ModuleMember -Function Get-AzDevOpsEnvironments

<#
    .SYNOPSIS
    Get all checks for an Azure Pipelines environment

    .DESCRIPTION
    Get all checks for an Azure Pipelines environment using Azure DevOps Rest API

    .PARAMETER TokenType
    Token Type for Azure DevOps, can be FullAccess, FineGrained or ReadOnly
    
    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER Environment
    Environment name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsEnvironmentChecks -Project $Project -Environment $Environment

    .NOTES
    Returns an empty array if no checks are found

    .LINK
    https://learn.microsoft.com/en-us/rest/api/azure/devops/approvalsandchecks/check-configurations/list?view=azure-devops-rest-7.2&tabs=HTTP
#>
function Get-AzDevOpsEnvironmentChecks {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'PAT')]
        [ValidateSet('FullAccess', 'FineGrained', 'ReadOnly')]
        [string]
        $TokenType = 'FullAccess',
        [Parameter(Mandatory)]
        [string]
        $Project,
        [Parameter(Mandatory)]
        [string]
        $Environment
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    # If token type is ReadOnly, write a warning and exit the function returing null
    if($TokenType -eq 'ReadOnly') {
        Write-Warning "Token type ReadOnly does not have access to Azure DevOps Pipelines Environments"
        return $null
    } else {
        $header = $script:connection.GetHeader()
        $Organization = $script:connection.Organization
        Write-Verbose "Getting checks for environment $Environment"
        $uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/checks/configurations?api-version=7.2-preview.1&resourceType=environment&resourceId=$($Environment)&`$expand=settings"
        Write-Verbose "URI: $uri"
        try {
            $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
            # If the response is a string and not an object, throw an exception for authentication failure or project not found
            if ($response -is [string]) {
                throw "Authentication failed or project not found"
            }
        }
        catch {
            throw $_.Exception.Message
        }
        $checks = $response.value
        if($null -eq $checks) {
            return @()
            # Else if $checks is not an array, but a single object
        } elseif ($null -eq $checks.Count -or $checks.Count -eq 0) {
            return @($checks)
        }
        return $checks
    }
}
Export-ModuleMember -Function Get-AzDevOpsEnvironmentChecks
<#
    .SYNOPSIS
    Export all Azure Pipelines environments to JSON files with their checks as nested objects

    .DESCRIPTION
    Export all Azure Pipelines environments to JSON files with their checks as nested objects using Azure DevOps Rest API

    .PARAMETER TokenType
    Token Type for Azure DevOps, can be FullAccess, FineGrained or ReadOnly

    .PARAMETER Project
    Project name for Azure DevOps

    .EXAMPLE
    Export-AzDevOpsEnvironmentChecks -Project $Project
#>
function Export-AzDevOpsEnvironmentChecks {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(ParameterSetName = 'PAT')]
        [ValidateSet('FullAccess', 'FineGrained', 'ReadOnly')]
        [string]
        $TokenType = 'FullAccess',
        [Parameter(Mandatory)]
        [string]
        $Project,
        [Parameter(Mandatory)]
        [string]
        $OutputPath

    )
    # If token type is ReadOnly, write a warning and exit the function returing null
    if($TokenType -eq 'ReadOnly') {
        Write-Warning "Token type ReadOnly does not have access to Azure DevOps Pipelines Environments"
        return $null
    } else {
        $environments = Get-AzDevOpsEnvironments -TokenType $TokenType -Project $Project
        $environments | ForEach-Object {
            if($null -ne $_) {
                $environment = $_
                # Add a ObjectType indicator for Azure.DevOps.Pipelines.Environment
                $environment | Add-Member -MemberType NoteProperty -Name ObjectType -Value 'Azure.DevOps.Pipelines.Environment'
                $checks = @(Get-AzDevOpsEnvironmentChecks -TokenType $TokenType -Project $Project -Environment $environment.id)
                $environment | Add-Member -MemberType NoteProperty -Name checks -Value $checks
                Write-Verbose "Exporting environment $($environment.name) to JSON"
                Write-Verbose "Output file: $OutputPath\$($environment.name).ado.env.json"
                $environment | ConvertTo-Json -Depth 100 | Out-File -FilePath "$OutputPath\$($environment.name).ado.env.json"
            }
        }
    }
}
Export-ModuleMember -Function Export-AzDevOpsEnvironmentChecks
