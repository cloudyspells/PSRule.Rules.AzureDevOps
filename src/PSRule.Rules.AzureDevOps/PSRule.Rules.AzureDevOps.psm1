# PSRule.Rules.AzureDevOps.psm1
# PSRule module for Azure DevOps

# Dot source all function scripts from src/Functions
Get-ChildItem -Path "$PSScriptRoot/Functions/*.ps1" | ForEach-Object {
    . $_.FullName
}

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
    Export-AzDevOpsReposAndBranchPolicies -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsEnvironmentChecks -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsArmServiceConnections -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsPipelines -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsVariableGroups -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsReleaseDefinitions -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
}
Export-ModuleMember -Function Export-AzDevOpsRuleData
# End of Function Export-AzDevOpsRuleData
