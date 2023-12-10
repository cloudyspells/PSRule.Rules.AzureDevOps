<#
    .SYNOPSIS
    Get all variable groups for a project from Azure DevOps.

    .DESCRIPTION
    Get all variable groups for a project from Azure DevOps using the REST API.

    .PARAMETER Project
    The name of the Azure DevOps project.

    .EXAMPLE
    Get-AzDevOpsVariableGroups -Project 'myproject'
#>
Function Get-AzDevOpsVariableGroups {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Project
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $Organization = $script:connection.Organization
    Write-Verbose "Getting variable groups for project $Project"
    $url = "https://dev.azure.com/$Organization/$Project/_apis/distributedtask/variablegroups?api-version=7.2-preview.2"
    Write-Verbose "URI: $url"
    $header = $script:connection.GetHeader()
    # try to get the variable groups, throw a descriptive error if it fails for authentication or other reasons
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -Headers $header
        # If the response is not an object but a string, the authentication failed
        if ($response -is [string]) {
            throw "Authentication failed or project not found"
        }
    }
    catch {
        throw $_.Exception.Message
    }
    return @($response.value)
}
Export-ModuleMember -Function Get-AzDevOpsVariableGroups
# End of function Get-AzDevOpsVariableGroups

<#
    .SYNOPSIS
    Export variable groups to JSON files.

    .DESCRIPTION
    Export Azure DevOps variable groups for a project to JSON files.

    .PARAMETER Project
    The name of the Azure DevOps project.

    .PARAMETER OutputPath
    The path to export variable groups to.

    .EXAMPLE
    Export-AzDevOpsVariableGroups -Project 'myproject' -OutputPath 'C:\temp'

    .NOTES
    All variable group files will have a suffix of .ado.vg.json.

    .LINK
    https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/variablegroups/get-variable-groups?view=azure-devops-rest-7.2
#>
Function Export-AzDevOpsVariableGroups {
    param(
        [Parameter(Mandatory)]
        [string]
        $Project,

        [Parameter(Mandatory)]
        [string]
        $OutputPath
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $Organization = $script:connection.Organization
    $variableGroups = Get-AzDevOpsVariableGroups -Project $Project
    $variableGroups | ForEach-Object {
        $variableGroup = $_
        $variableGroup | Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value 'Azure.DevOps.Tasks.VariableGroup'
        $variableGroupName = $variableGroup.name
        $variableGroupPath = Join-Path -Path $OutputPath -ChildPath "$variableGroupName.ado.vg.json"
        Write-Verbose "Exporting variable group $variableGroupName as file $variableGroupName.ado.vg.json"
        $variableGroup | ConvertTo-Json -Depth 100 | Out-File -FilePath $variableGroupPath -Encoding UTF8
    }
}
Export-ModuleMember -Function Export-AzDevOpsVariableGroups
# End of function Export-AzDevOpsVariableGroups
