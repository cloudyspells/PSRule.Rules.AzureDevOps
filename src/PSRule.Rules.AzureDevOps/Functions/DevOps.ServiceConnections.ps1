<#
    .SYNOPSIS
    Get all Azure Resource Manager service connections from Azure DevOps project

    .DESCRIPTION
    Get all Azure Resource Manager service connections from Azure DevOps project using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsArmServiceConnections -PAT $PAT -Organization $Organization -Project $Project
#>
function Get-AzDevOpsArmServiceConnections {
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
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/serviceendpoint/endpoints?api-version=6.0-preview.4"
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
    return $response.value | Where-Object { $_.type -eq 'azurerm' }
}
Export-ModuleMember -Function Get-AzDevOpsArmServiceConnections
# End of Function Get-AzDevOpsArmServiceConnections

<#
    .SYNOPSIS
    Get all Checks for service connections from Azure DevOps project

    .DESCRIPTION
    Get all Checks for service connections from Azure DevOps project using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER ServiceConnectionId
    Service connection id for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsArmServiceConnectionChecks -PAT $PAT -Organization $Organization -Project $Project -ServiceConnectionId $ServiceConnectionId

    .LINK
    https://learn.microsoft.com/en-us/rest/api/azure/devops/approvalsandchecks/check-configurations/list?view=azure-devops-rest-7.2&tabs=HTTP
#>
function Get-AzDevOpsArmServiceConnectionChecks {
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
        $ServiceConnectionId
    )
    $header = Get-AzDevOpsHeader -PAT $PAT
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/pipelines/checks/configurations?api-version=7.2-preview.1&resourceType=endpoint&resourceId=$ServiceConnectionId"
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
Export-ModuleMember -Function Get-AzDevOpsArmServiceConnectionChecks
# End of Function Get-AzDevOpsArmServiceConnectionChecks

<#
    .SYNOPSIS
    Export all Azure Resource Manager service connections from Azure DevOps project with checks as nested objects

    .DESCRIPTION
    Export all Azure Resource Manager service connections from Azure DevOps project with checks as nested objects using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER OutputPath
    Output path for JSON files

    .EXAMPLE
    Export-AzDevOpsArmServiceConnections -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath

    .LINK
    https://learn.microsoft.com/en-us/rest/api/azure/devops/approvalsandchecks/check-configurations/list?view=azure-devops-rest-7.2&tabs=HTTP
#>
function Export-AzDevOpsArmServiceConnections {
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
    # Get all service connections
    $serviceConnections = Get-AzDevOpsArmServiceConnections -PAT $PAT -Organization $Organization -Project $Project
    $serviceConnections | ForEach-Object {
        $serviceConnection = $_
        # Set JSON ObjectType field to Azure.DevOps.ServiceConnection
        $serviceConnection | Add-Member -MemberType NoteProperty -Name ObjectType -Value 'Azure.DevOps.ServiceConnection'
        # Get checks for service connection
        $serviceConnectionChecks = @(Get-AzDevOpsArmServiceConnectionChecks -PAT $PAT -Organization $Organization -Project $Project -ServiceConnectionId $serviceConnection.id)
        $serviceConnection | Add-Member -MemberType NoteProperty -Name Checks -Value $serviceConnectionChecks
        Write-Verbose "Exporting service connection $($serviceConnection.name) as file $($serviceConnection.name).ado.sc.json"
        $serviceConnection | ConvertTo-Json -Depth 100 | Out-File "$OutputPath/$($serviceConnection.name).ado.sc.json"
    }
}
Export-ModuleMember -Function Export-AzDevOpsArmServiceConnections
# End of Function Export-AzDevOpsArmServiceConnections