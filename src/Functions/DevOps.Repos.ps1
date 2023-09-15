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
    $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
    return $response.value 
}
Export-ModuleMember -Function Get-AzDevOpsRepos
# End of Function Get-AzDevOpsRepos

<#
    .SYNOPSIS
    Get all default, main and master branches from Azure DevOps repos

    .DESCRIPTION
    Get all default, main and master branches from Azure DevOps repos using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER Repository
    Repository name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsDefaultBranch -PAT $PAT -Organization $Organization -Project $Project -Repository $Repository
#>
Function Get-AzDevOpsDefaultBranch {
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
        $Repository
    )
    $header = Get-AzDevOpsHeader -PAT $PAT
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories/$Repository/refs?api-version=6.0"
    $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
    # Get the default branch
    $defaultBranch = $response.value | Where-Object {$_.name -eq "refs/heads/main" -or $_.name -eq "refs/heads/master"}

    return $defaultBranch
}
Export-ModuleMember -Function Get-AzDevOpsDefaultBranch
# End of Function Get-AzDevOpsDefaultBranch

