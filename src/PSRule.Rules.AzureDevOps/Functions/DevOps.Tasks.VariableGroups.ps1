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
    Get Acls for a variable group from Azure DevOps.

    .DESCRIPTION
    Get Acls for a variable group from Azure DevOps using the REST API.

    .PARAMETER ProjectId
    The id of the Azure DevOps project.

    .PARAMETER VariableGroupId
    The id of the Azure DevOps variable group.

    .EXAMPLE
    Get-AzDevOpsVariableGroupAcls -ProjectId 'myproject' -VariableGroupId 1
#>
function Get-AzDevOpsVariableGroupAcls {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ProjectId,
        [Parameter(Mandatory)]
        [string]$VariableGroupId
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $Organization = $script:connection.Organization
    Write-Verbose "Getting variable group acls for project $ProjectId and variable group $VariableGroupId"
    $uri = "https://dev.azure.com/{0}/_apis/accesscontrollists/b7e84409-6553-448a-bbb2-af228e07cbeb?api-version=7.2-preview.1&token=Library/{1}/VariableGroup/{2}" -f $Organization, $ProjectId, $VariableGroupId
    Write-Verbose "URI: $uri"
    $header = $script:connection.GetHeader()
    # try to get the variable group acls, throw a descriptive error if it fails for authentication or other reasons
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
    return @($response.value)
}
Export-ModuleMember -Function Get-AzDevOpsVariableGroupAcls

<#
    .SYNOPSIS
    Export variable groups to JSON files.

    .DESCRIPTION
    Export Azure DevOps variable groups for a project to JSON files.

    .PARAMETER Project
    The name of the Azure DevOps project.

    .PARAMETER OutputPath
    The path to export variable groups to.

    .PARAMETER PassThru
    Return the exported variable groups as objects to the pipeline instead of writing to a file.

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
    $ProjectId = (Get-AzDevOpsProject -Project $Project).id
    $variableGroups = Get-AzDevOpsVariableGroups -Project $Project
    $variableGroups | ForEach-Object {
        $variableGroup = $_
        $variableGroup | Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value 'Azure.DevOps.Tasks.VariableGroup'
        $variableGroup | Add-Member -MemberType NoteProperty -Name 'ObjectName' -Value "$Organization.$Project.$($variableGroup.name)"
        # Add the variable group acls
        $variableGroupAcls = @(Get-AzDevOpsVariableGroupAcls -ProjectId $ProjectId -VariableGroupId $variableGroup.id)
        $variableGroup | Add-Member -MemberType NoteProperty -Name 'Acls' -Value $variableGroupAcls
        # Set the id to a JSON object with the originalId, project and organization
        $variableGroup.id = @{
            originalId = $variableGroup.id
            resourceName = $variableGroup.name
            project = $Project
            organization = $Organization
        } | ConvertTo-Json -Depth 100
        $variableGroupName = $variableGroup.name
        if ($PassThru) {
            Write-Output $variableGroup
        } else {
            $variableGroupPath = Join-Path -Path $OutputPath -ChildPath "$variableGroupName.ado.vg.json"
            Write-Verbose "Exporting variable group $variableGroupName as file $variableGroupName.ado.vg.json"
            $variableGroup | ConvertTo-Json -Depth 100 | Out-File -FilePath $variableGroupPath -Encoding UTF8
        }
    }
}
Export-ModuleMember -Function Export-AzDevOpsVariableGroups
# End of function Export-AzDevOpsVariableGroups
