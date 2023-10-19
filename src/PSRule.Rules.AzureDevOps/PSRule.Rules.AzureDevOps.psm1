# PSRule.Rules.AzureDevOps.psm1
# PSRule module for Azure DevOps

# Dot source all function scripts from src/Functions
Get-ChildItem -Path "$PSScriptRoot/Functions/*.ps1" | ForEach-Object {
    . $_.FullName
}

# Dot source all ps1 files from the modules Functions folder



<#
    .SYNOPSIS
    Run all JSON export functions for Azure DevOps for analysis by PSRule

    .DESCRIPTION
    Run all JSON export functions for Azure DevOps using Azure DevOps Rest API and this modules functions for analysis by PSRule

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER OutputPath
    Output path for JSON files

    .EXAMPLE
    Export-AzDevOpsRuleData -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
#>
Function Export-AzDevOpsRuleData {
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
    Export-AzDevOpsReposAndBranchPolicies -PAT $PAT -TokenType $TokenType -Organization $Organization -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsEnvironmentChecks -PAT $PAT -TokenType $TokenType -Organization $Organization -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsServiceConnections -PAT $PAT -TokenType $TokenType -Organization $Organization -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsPipelines -PAT $PAT -TokenType $TokenType -Organization $Organization -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsPipelinesSettings -PAT $PAT -TokenType $TokenType -Organization $Organization -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsVariableGroups -PAT $PAT -TokenType $TokenType -Organization $Organization -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsReleaseDefinitions -PAT $PAT -TokenType $TokenType -Organization $Organization -Project $Project -OutputPath $OutputPath
}
Export-ModuleMember -Function Export-AzDevOpsRuleData -Alias Export-AzDevOpsProjectRuleData
# End of Function Export-AzDevOpsRuleData

<#
    .SYNOPSIS
    Export rule data for all projects in the DevOps organization

    .DESCRIPTION
    Export rule data for all projects in the DevOps organization using Azure DevOps Rest API and this modules functions for analysis by PSRule

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER TokenType
    Token type for Azure DevOps (FullAccess, FineGrained, ReadOnly)

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER OutputPath
    Output path for JSON files

    .EXAMPLE
    Export-AzDevOpsOrganizationRuleData -PAT $PAT -Organization $Organization -OutputPath $OutputPath
#>
Function Export-AzDevOpsOrganizationRuleData {
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
        $OutputPath
    )
    $projects = Get-AzDevOpsProjects -PAT $PAT -TokenType $TokenType -Organization $Organization
    $projects | ForEach-Object {
        $project = $_
        # Create a subfolder for each project
        $subPath = "$($OutputPath)\$($project.name)"
        if(!(Test-Path -Path $subPath)) {
            New-Item -Path $subPath -ItemType Directory
        }
        Export-AzDevOpsRuleData -PAT $PAT -TokenType $TokenType -Organization $Organization -Project $project.name -OutputPath $subPath
    }
}
Export-ModuleMember -Function Export-AzDevOpsOrganizationRuleData
# End of Function Export-AzDevOpsOrganizationRuleData
