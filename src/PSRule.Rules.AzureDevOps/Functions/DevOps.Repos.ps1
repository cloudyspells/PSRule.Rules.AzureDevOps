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
    Write-Verbose "Getting repos for project $Project"
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories?api-version=6.0"
    Write-Verbose "URI: $uri"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        # If the response is a string and not an object, throw an exception for authentication failure or project not found
        if ($response -is [string]) {
            throw "Authentication failed or project not found"	
        }
    }
    catch {
        throw $_.Exception.Message
    }
    return @($response.value)
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
    Write-Verbose "Getting branch policy for branch $Branch in repo $Repository in project $Project"
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/policy/configurations?api-version=6.0"
    Write-Verbose "URI: $uri"
    # Try to get the branch policy, return an empty object if no branch policy is found for the branch
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        # If the response is a string and not an object, throw an exception for authentication failure or project not found
        if ($response -is [string]) {
            throw "Authentication failed or project not found"	
        }
    }
    catch {
        throw $_.Exception.Message
    }
    $branchPolicy = $response.value | Where-Object {$_.settings.scope.refName -eq $Branch -and $_.settings.scope.repositoryId -eq $Repository}

    return $branchPolicy
}
Export-ModuleMember -Function Get-AzDevOpsBranchPolicy
# End of Function Get-AzDevOpsBranchPolicy

<#
    .SYNOPSIS
    Check the existance of a file in an Azure DevOps repo

    .DESCRIPTION
    Check the existance of a file in an Azure DevOps repo using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER Repository
    Repository name for Azure DevOps

    .PARAMETER Path
    Path to file in repo

    .EXAMPLE
    Test-AzDevOpsFileExists -PAT $PAT -Organization $Organization -Project $Project -Repository $Repository -Path $Path

    .NOTES
    This function return $true if the file exists and $false if it does not
#>
function Test-AzDevOpsFileExists {
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
        $Path
    )
    $header = Get-AzDevOpsHeader -PAT $PAT
    Write-Verbose "Checking if file $Path exists in repo $Repository in project $Project"
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/git/repositories/$Repository/items?path=$Path&api-version=6.0"
    Write-Verbose "URI: $uri"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
    }
    catch {
        return $false
    }
    return $true
}
Export-ModuleMember -Function Test-AzDevOpsFileExists
# End of Function Test-AzDevOpsFileExists

<#
    .SYNOPSIS
    Get Azure DevOps organization information

    .DESCRIPTION
    Get Azure DevOps organization information using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsOrganization -PAT $PAT -Organization $Organization
#>

<#
    .SYNOPSIS
    Get GitHub Advanced Security (GHAS) data for a repository

    .DESCRIPTION
    Get GitHub Advanced Security (GHAS) data for a repository using Azure DevOps Rest API

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER Repository
    Repository name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsRepositoryGhas -PAT $PAT -Organization $Organization -Project $Project -Repository $Repository
#>
Function Get-AzDevOpsRepositoryGhas {
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
    # Get the repository
    $repo = Get-AzDevOpsRepos -PAT $PAT -Organization $Organization -Project $Project | ?{ $_.name -eq $Repository }
    # Get the repository id
    $repoId = $repo.id
    # Get the project id
    $projectId = $repo.project.id
    $payload = @{
        contributionIds = @(
            "ms.vss-features.my-organizations-data-provider"
            "ms.vss-advsec.advanced-security-enablement-data-provider"
        )
        dataProviderContext = @{
            properties = @{
                givenProjectId = $projectId
                givenRepoId = $repoId
            }
        }
    }
    $url = "https://dev.azure.com/$Organization/_apis/Contribution/HierarchyQuery?api-version=5.0-preview.1"
    Write-Verbose "Getting repository $Repository in project $Project in organization $Organization"
    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Headers $header -Body ($payload | ConvertTo-Json) -ContentType "application/json"
    }
    catch {
        throw $_.Exception.Message
    }
    return $response.dataProviders.'ms.vss-advsec.advanced-security-enablement-data-provider'
}
Export-ModuleMember -Function Get-AzDevOpsRepositoryGhas
# End of Function Get-AzDevOpsRepositoryGhas

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
    # Get all repos in project
    $repos = Get-AzDevOpsRepos -PAT $PAT -Organization $Organization -Project $Project
    $repos | ForEach-Object {
        if ($null -ne $_) {
            $repo = $_
            # Add ObjectType Azure.DevOps.Repo to repo object
            $repo | Add-Member -MemberType NoteProperty -Name ObjectType -Value "Azure.DevOps.Repo"
            Write-Verbose "Getting branch policy for repo $($repo.name)"
            $branchPolicy = Get-AzDevOpsBranchPolicy -PAT $PAT -Organization $Organization -Project $Project -Repository $repo.id -Branch $repo.defaultBranch
            $repo | Add-Member -MemberType NoteProperty -Name MainBranchPolicy -Value $branchPolicy
            # Add a property indicating if a file named README.md or README exists in the repo
            $readmeExists = ((Test-AzDevOpsFileExists -PAT $PAT -Organization $Organization -Project $Project -Repository $repo.id -Path "README.md") -or (Test-AzDevOpsFileExists -PAT $PAT -Organization $Organization -Project $Project -Repository $repo.id -Path "README"))
            $repo | Add-Member -MemberType NoteProperty -Name ReadmeExists -Value $readmeExists
            
            # Add a property indicating if a file named LICENSE or LICENSE.md exists in the repo
            $licenseExists = ((Test-AzDevOpsFileExists -PAT $PAT -Organization $Organization -Project $Project -Repository $repo.id -Path "LICENSE") -or (Test-AzDevOpsFileExists -PAT $PAT -Organization $Organization -Project $Project -Repository $repo.id -Path "LICENSE.md"))
            $repo | Add-Member -MemberType NoteProperty -Name LicenseExists -Value $licenseExists

            # Add a property for GitHub Advanced Security (GHAS) data
            $ghas = Get-AzDevOpsRepositoryGhas -PAT $PAT -Organization $Organization -Project $Project -Repository $repo.name
            $repo | Add-Member -MemberType NoteProperty -Name Ghas -Value $ghas

            # Export repo object to JSON file
            Write-Verbose "Exporting repo $($repo.name) to JSON as file $($repo.name).ado.repo.json"
            $repo | ConvertTo-Json -Depth 100 | Out-File -FilePath "$OutputPath\$($repo.name).ado.repo.json"
        }
    }
}
Export-ModuleMember -Function Export-AzDevOpsReposAndBranchPolicies
# End of Function Export-AzDevOpsReposAndBranchPolicies
