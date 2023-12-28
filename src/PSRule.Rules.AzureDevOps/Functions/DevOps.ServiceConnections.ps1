<#
    .SYNOPSIS
    Get all Azure Resource Manager service connections from Azure DevOps project

    .DESCRIPTION
    Get all Azure Resource Manager service connections from Azure DevOps project using Azure DevOps Rest API

    .PARAMETER Project
    Project name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsServiceConnections -Project $Project
#>
function Get-AzDevOpsServiceConnections {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Project
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $Organization = $script:connection.Organization
    $header = $script:connection.GetHeader()
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

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER ServiceConnectionId
    Service connection id for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsServiceConnectionChecks -Project $Project -ServiceConnectionId $ServiceConnectionId

    .LINK
    https://learn.microsoft.com/en-us/rest/api/azure/devops/approvalsandchecks/check-configurations/list?view=azure-devops-rest-7.2&tabs=HTTP
#>
function Get-AzDevOpsServiceConnectionChecks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Project,
        [Parameter(Mandatory)]
        [string]
        $ServiceConnectionId
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $Organization = $script:connection.Organization
    $header = $script:connection.GetHeader()
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

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER OutputPath
    Output path for JSON files

    .PARAMETER PassThru
    Return the exported service connections as objects to the pipeline instead of writing to a file

    .EXAMPLE
    Export-AzDevOpsServiceConnections -Project $Project -OutputPath $OutputPath

    .LINK
    https://learn.microsoft.com/en-us/rest/api/azure/devops/approvalsandchecks/check-configurations/list?view=azure-devops-rest-7.2&tabs=HTTP
#>
function Export-AzDevOpsServiceConnections {
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
    $Organization = $script:connection.Organization
    # Get all service connections
    $serviceConnections = Get-AzDevOpsServiceConnections -Project $Project
    $serviceConnections | ForEach-Object {
        $serviceConnection = $_
        # Set JSON ObjectType field to Azure.DevOps.ServiceConnection
        $serviceConnection | Add-Member -MemberType NoteProperty -Name ObjectType -Value 'Azure.DevOps.ServiceConnection'
        # Set JSON ObjectName field to organiztion.project.service connection name
        $serviceConnection | Add-Member -MemberType NoteProperty -Name ObjectName -Value "$Organization.$Project.$($serviceConnection.name)"
        # Get checks for service connection
        $serviceConnectionChecks = @(Get-AzDevOpsServiceConnectionChecks -Project $Project -ServiceConnectionId $serviceConnection.id)
        $serviceConnection | Add-Member -MemberType NoteProperty -Name Checks -Value $serviceConnectionChecks
        if ($PassThru) {
            Write-Output $serviceConnection
        } else {
            Write-Verbose "Exporting service connection $($serviceConnection.name) as file $($serviceConnection.name).ado.sc.json"
            $serviceConnection | ConvertTo-Json -Depth 100 | Out-File "$OutputPath/$($serviceConnection.name).ado.sc.json"
        }
    }
}
Export-ModuleMember -Function Export-AzDevOpsServiceConnections
# End of Function Export-AzDevOpsServiceConnections
