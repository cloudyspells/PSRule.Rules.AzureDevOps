<#
    .SYNOPSIS
    Get all Azure Resource Manager service connections from Azure DevOps project

    .DESCRIPTION
    Get all Azure Resource Manager service connections from Azure DevOps project using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER TokenType
    Token type for Azure DevOps (FullAccess, FineGrained, ReadOnly)

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsServiceConnections -PAT $PAT -Organization $Organization -Project $Project
#>
function Get-AzDevOpsServiceConnections {
    [CmdletBinding(DefaultParameterSetName = 'PAT')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'PAT')]
        [string]
        $PAT,
        [Parameter(ParameterSetName = 'PAT')]
        [ValidateSet('FullAccess', 'FineGrained', 'ReadOnly')]
        [string]
        $TokenType = 'FullAccess',
        [Parameter(Mandatory, ParameterSetName = 'PAT')]
        [string]
        $Organization,
        [Parameter(Mandatory, ParameterSetName = 'PAT')]
        [string]
        $Project
    )
    $header = Get-AzDevOpsHeader -PAT $PAT
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/serviceendpoint/endpoints?api-version=6.0-preview.4&includeDetails=True"
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

    $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
    return $response.value
}
Export-ModuleMember -Function Get-AzDevOpsServiceConnections
# End of Function Get-AzDevOpsServiceConnections

<#
    .SYNOPSIS
    Get all Checks for service connections from Azure DevOps project

    .DESCRIPTION
    Get all Checks for service connections from Azure DevOps project using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER TokenType
    Token type for Azure DevOps (FullAccess, FineGrained, ReadOnly)

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER ServiceConnectionId
    Service connection id for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsServiceConnectionChecks -PAT $PAT -Organization $Organization -Project $Project -ServiceConnectionId $ServiceConnectionId

    .LINK
    https://learn.microsoft.com/en-us/rest/api/azure/devops/approvalsandchecks/check-configurations/list?view=azure-devops-rest-7.2&tabs=HTTP
#>
function Get-AzDevOpsServiceConnectionChecks {
    [CmdletBinding(DefaultParameterSetName = 'PAT')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'PAT')]
        [string]
        $PAT,
        [Parameter(ParameterSetName = 'PAT')]
        [ValidateSet('FullAccess', 'FineGrained', 'ReadOnly')]
        [string]
        $TokenType = 'FullAccess',
        [Parameter(Mandatory, ParameterSetName = 'PAT')]
        [string]
        $Organization,
        [Parameter(Mandatory, ParameterSetName = 'PAT')]
        [string]
        $Project,
        [Parameter(Mandatory, ParameterSetName = 'PAT')]
        [string]
        $ServiceConnectionId
    )
    $header = Get-AzDevOpsHeader -PAT $PAT
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/checks/configurations?api-version=7.2-preview.1&resourceType=endpoint&resourceId=$ServiceConnectionId&`$expand=settings"
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
Export-ModuleMember -Function Get-AzDevOpsServiceConnectionChecks
# End of Function Get-AzDevOpsServiceConnectionChecks

<#
    .SYNOPSIS
    Export all Azure Resource Manager service connections from Azure DevOps project with checks as nested objects

    .DESCRIPTION
    Export all Azure Resource Manager service connections from Azure DevOps project with checks as nested objects using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER TokenType
    Token type for Azure DevOps (FullAccess, FineGrained, ReadOnly)

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER OutputPath
    Output path for JSON files

    .EXAMPLE
    Export-AzDevOpsServiceConnections -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath

    .LINK
    https://learn.microsoft.com/en-us/rest/api/azure/devops/approvalsandchecks/check-configurations/list?view=azure-devops-rest-7.2&tabs=HTTP
#>
function Export-AzDevOpsServiceConnections {
    [CmdletBinding(DefaultParameterSetName = 'PAT')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'PAT')]
        [string]
        $PAT,
        [Parameter(ParameterSetName = 'PAT')]
        [ValidateSet('FullAccess', 'FineGrained', 'ReadOnly')]
        [string]
        $TokenType = 'FullAccess',
        [Parameter(Mandatory, ParameterSetName = 'PAT')]
        [string]
        $Organization,
        [Parameter(Mandatory, ParameterSetName = 'PAT')]
        [string]
        $Project,
        [Parameter(Mandatory, ParameterSetName = 'PAT')]
        [string]
        $OutputPath
    )
    # Get all service connections
    $serviceConnections = Get-AzDevOpsServiceConnections -PAT $PAT -Organization $Organization -Project $Project
    $serviceConnections | ForEach-Object {
        $serviceConnection = $_
        # Set JSON ObjectType field to Azure.DevOps.ServiceConnection
        $serviceConnection | Add-Member -MemberType NoteProperty -Name ObjectType -Value 'Azure.DevOps.ServiceConnection'
        # Get checks for service connection
        $serviceConnectionChecks = @(Get-AzDevOpsServiceConnectionChecks -PAT $PAT -Organization $Organization -Project $Project -ServiceConnectionId $serviceConnection.id)
        $serviceConnection | Add-Member -MemberType NoteProperty -Name Checks -Value $serviceConnectionChecks
        Write-Verbose "Exporting service connection $($serviceConnection.name) as file $($serviceConnection.name).ado.sc.json"
        $serviceConnection | ConvertTo-Json -Depth 100 | Out-File "$OutputPath/$($serviceConnection.name).ado.sc.json"
    }
}
Export-ModuleMember -Function Export-AzDevOpsServiceConnections
# End of Function Export-AzDevOpsServiceConnections
