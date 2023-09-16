<#
    .SYNOPSIS
    Get all repos from Azure DevOps project

    .DESCRIPTION
    Get all repos from Azure DevOps project using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsRepos -PAT $PAT -Organization $Organization -Project $Project
#>
Function Get-AzDevOpsRepos {
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
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories?api-version=6.0"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
    }
    catch {
        Write-Warning "No repos found for project $Project"
        return $null
    }
    return $response.value
}
Export-ModuleMember -Function Get-AzDevOpsRepos
# End of Function Get-AzDevOpsRepos

<#
    .SYNOPSIS
    Get Azure DevOps branch policy for a branch in a repo

    .DESCRIPTION
    Get Azure DevOps branch policy for a branch in a repo using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER Repository
    Repository name for Azure DevOps

    .PARAMETER Branch
    Branch name for Azure DevOps as a git ref. Example: refs/heads/main

    .EXAMPLE
    Get-AzDevOpsBranchPolicy -PAT $PAT -Organization $Organization -Project $Project -Repository $Repository -Branch $Branch

    .NOTES
    This function returns an empty object if no branch policy is found for the branch
#>
Function Get-AzDevOpsBranchPolicy {
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
        $Repository,
        [Parameter()]
        [string]
        $Branch
    )
    $header = Get-AzDevOpsHeader -PAT $PAT
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/policy/configurations?api-version=6.0"
    $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
    $branchPolicy = $response.value | Where-Object {$_.settings.scope.refName -eq $Branch -and $_.settings.scope.repositoryId -eq $Repository}

    return $branchPolicy
}
Export-ModuleMember -Function Get-AzDevOpsBranchPolicy
# End of Function Get-AzDevOpsBranchPolicy

<#
    .SYNOPSIS
    Get and export all Azure DevOps repos in a project with default, main and master branches and branch policies and export to JSON with 1 file per repo

    .DESCRIPTION
    Get and export all Azure DevOps repos in a project with default, main and master branches and branch policies and export to JSON using Azure DevOps Rest API and this modules functions

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER OutputPath
    Output path for JSON file

    .EXAMPLE
    Export-AzDevOpsReposAndBranchPolicies -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath

    .NOTES
    This function returns an empty object if no branch policy is found for the branch
#>
function Export-AzDevOpsReposAndBranchPolicies {
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
    $repos = Get-AzDevOpsRepos -PAT $PAT -Organization $Organization -Project $Project
    $repos | ForEach-Object {
        if ($null -ne $_) {
            $repo = $_
            # Add ObjectType Azure.DevOps.Repo to repo object
            $repo | Add-Member -MemberType NoteProperty -Name ObjectType -Value "Azure.DevOps.Repo"
            $branchPolicy = Get-AzDevOpsBranchPolicy -PAT $PAT -Organization $Organization -Project $Project -Repository $repo.id -Branch $repo.defaultBranch
            $repo | Add-Member -MemberType NoteProperty -Name MainBranchPolicy -Value $branchPolicy
            # Export repo object to JSON file
            $repo | ConvertTo-Json -Depth 100 | Out-File -FilePath "$OutputPath\$($repo.name).ado.repo.json"
        }
    }
}
Export-ModuleMember -Function Get-AzDevOpsReposAndBranchPolicies
# End of Function Get-AzDevOpsReposAndBranchPolicies
