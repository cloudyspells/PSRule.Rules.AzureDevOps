<#
    .SYNOPSIS
    Get all variable groups for a project from Azure DevOps.

    .DESCRIPTION
    Get all variable groups for a project from Azure DevOps using the REST API.

    .PARAMETER Organization
    The name of the Azure DevOps organization.

    .PARAMETER Project
    The name of the Azure DevOps project.

    .PARAMETER PAT
    A personal access token (PAT) used to authenticate with Azure DevOps.

    .EXAMPLE
    Get-AzDevOpsVariableGroups -Organization 'myorganization' -Project 'myproject' -PAT $myPAT
#>
Function Get-AzDevOpsVariableGroups {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$PAT
    )
    $url = "https://dev.azure.com/$Organization/$Project/_apis/distributedtask/variablegroups?api-version=7.2-preview.2"
    $header = Get-AzDevOpsHeader -PAT $PAT
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers $header
    return @($response.value)
}
# End of function Get-AzDevOpsVariableGroups

<#
    .SYNOPSIS
    Export variable groups to JSON files.

    .DESCRIPTION
    Export Azure DevOps variable groups for a project to JSON files.

    .PARAMETER Organization
    The name of the Azure DevOps organization.

    .PARAMETER Project
    The name of the Azure DevOps project.

    .PARAMETER PAT
    A personal access token (PAT) used to authenticate with Azure DevOps.

    .PARAMETER OutputPath
    The path to export variable groups to.

    .EXAMPLE
    Export-AzDevOpsVariableGroups -Organization 'myorganization' -Project 'myproject' -PAT $myPAT -OutputPath 'C:\temp'

    .NOTES
    All variable group files will have a suffix of .ado.vg.json.

    .LINK
    https://docs.microsoft.com/en-us/rest/api/azure/devops/distributedtask/variablegroups/get-variable-groups?view=azure-devops-rest-7.2
#>
Function Export-AzDevOpsVariableGroups {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$PAT,

        [Parameter(Mandatory = $true)]
        [string]$OutputPath
    )
    $variableGroups = Get-AzDevOpsVariableGroups -Organization $Organization -Project $Project -PAT $PAT
    $variableGroups | ForEach-Object {
        $variableGroup = $_
        $variableGroup | Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value 'Azure.DevOps.Tasks.VariableGroup'
        $variableGroupName = $variableGroup.name
        $variableGroupPath = Join-Path -Path $OutputPath -ChildPath "$variableGroupName.ado.vg.json"
        $variableGroup | ConvertTo-Json | Out-File -FilePath $variableGroupPath -Encoding UTF8
    }
}
# End of function Export-AzDevOpsVariableGroups
