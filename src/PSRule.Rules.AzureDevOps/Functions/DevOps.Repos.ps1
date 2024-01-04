<#
    .SYNOPSIS
    Get all repos from Azure DevOps project

    .DESCRIPTION
    Get all repos from Azure DevOps project using Azure DevOps Rest API

    .PARAMETER Project
    Project name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsRepos -Project $Project
#>
Function Get-AzDevOpsRepos {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
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
    Get Azure DevOps branches for a repo

    .DESCRIPTION
    Get Azure DevOps branches for a repo using Azure DevOps Rest API

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER Repository
    Repository name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsBranches -Project $Project -Repository $Repository
#>
Function Get-AzDevOpsBranches {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory)]
        [string]
        $Project,
        [Parameter(Mandatory)]
        [string]
        $Repository
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $Organization = $script:connection.Organization
    $header = $script:connection.GetHeader()
    Write-Verbose "Getting branches for repo $Repository in project $Project"
    $uri = "https://dev.azure.com/$Organization/_apis/git/repositories/$Repository/refs?filter=heads&api-version=7.2-preview.2"
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
Export-ModuleMember -Function Get-AzDevOpsBranches

<#
    .SYNOPSIS
    Get Azure DevOps branch policy for a branch in a repo

    .DESCRIPTION
    Get Azure DevOps branch policy for a branch in a repo using Azure DevOps Rest API

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER Repository
    Repository name for Azure DevOps

    .PARAMETER Branch
    Branch name for Azure DevOps as a git ref. Example: refs/heads/main

    .EXAMPLE
    Get-AzDevOpsBranchPolicy -Project $Project -Repository $Repository -Branch $Branch

    .NOTES
    This function returns an empty object if no branch policy is found for the branch
#>
Function Get-AzDevOpsBranchPolicy {
    [CmdletBinding()]
    [OutputType([object[]])]
    param (
        [Parameter(Mandatory)]
        [string]
        $Project,
        [Parameter(Mandatory)]
        [string]
        $Repository,
        [Parameter(Mandatory)]
        [string]
        $Branch
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $Organization = $script:connection.Organization
    $header = $script:connection.GetHeader()
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
    $branchPolicy = @($response.value | Where-Object {$_.settings.scope.refName -eq $Branch -and $_.settings.scope.repositoryId -eq $Repository})

    return $branchPolicy
}
Export-ModuleMember -Function Get-AzDevOpsBranchPolicy
# End of Function Get-AzDevOpsBranchPolicy

<#
    .SYNOPSIS
    Get Repository pipeline permissions for a repo

    .DESCRIPTION
    Get Repository pipeline permissions for a repo using Azure DevOps Rest API

    .PARAMETER ProjectId
    Project ID for Azure DevOps project

    .PARAMETER RepositoryId
    Repository ID for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsRepositoryPipelinePermissions -ProjectId $ProjectId -RepositoryId $RepositoryId
#>
Function Get-AzDevOpsRepositoryPipelinePermissions {
    [CmdletBinding()]
    [OutputType([object[]])]
    param (
        [Parameter(Mandatory)]
        [string]
        $ProjectId,
        [Parameter(Mandatory)]
        [string]
        $RepositoryId
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $Organization = $script:connection.Organization
    $header = $script:connection.GetHeader()
    $uri = "https://dev.azure.com/{0}/{1}/_apis/pipelines/pipelinePermissions/repository/{2}.{3}" -f $Organization, $ProjectId, $ProjectId, $RepositoryId
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header -ContentType "application/json"
        # If the response is a string and not an object, throw an exception for authentication failure or project not found
        if ($response -is [string]) {
            throw "Authentication failed or project not found"
        }
    }
    catch {
        throw $_.Exception.Message
    }
    return $response
}
Export-ModuleMember -Function Get-AzDevOpsRepositoryPipelinePermissions
# End of Function Get-AzDevOpsRepositoryPipelinePermissions

<#
    .SYNOPSIS
    Get Azure DevOps repos ACLs

    .DESCRIPTION
    Get Azure DevOps repos ACLs using Azure DevOps Rest API

    .PARAMETER ProjectId
    Project ID for Azure DevOps project

    .PARAMETER RepositoryId
    Repository ID for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsRepositoryAcls -ProjectId $ProjectId -RepositoryId $RepositoryId
#>
Function Get-AzDevOpsRepositoryAcls {
    [CmdletBinding()]
    [OutputType([object[]])]
    param (
        [Parameter(Mandatory)]
        [string]
        $ProjectId,
        [Parameter(Mandatory)]
        [string]
        $RepositoryId
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $Organization = $script:connection.Organization
    $TokenType = $script:connection.TokenType
    # If the token type is ReadOnly, write a warning and return null
    if ($TokenType -eq "ReadOnly") {
        Write-Warning "The ReadOnly token type does not have access to the Repositories ACLs API, returning null"
        return $null
    } else {
        $header = $script:connection.GetHeader()
        $uri = "https://dev.azure.com/{0}/_apis/accesscontrollists/2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87?api-version=6.0" -f $Organization
        try {
            $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header -ContentType "application/json"
            # If the response is a string and not an object, throw an exception for authentication failure or project not found
            if ($response -is [string]) {
                throw "Authentication failed or project not found"
            }
            $thisRepoPerms = $response.value | where-object {($_.token -eq "repoV2/$($ProjectId)/$($RepositoryId)")}
        }
        catch {
            throw $_.Exception.Message
        }
        return $thisRepoPerms
    }
}
Export-ModuleMember -Function Get-AzDevOpsRepositoryAcls
# End of Function Get-AzDevOpsRepositoryAcls

<#
    .SYNOPSIS
    Check the existance of a file in an Azure DevOps repo

    .DESCRIPTION
    Check the existance of a file in an Azure DevOps repo using Azure DevOps Rest API

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER Repository
    Repository name for Azure DevOps

    .PARAMETER Path
    Path to file in repo

    .EXAMPLE
    Test-AzDevOpsFileExists -Project $Project -Repository $Repository -Path $Path

    .NOTES
    This function return $true if the file exists and $false if it does not
#>
function Test-AzDevOpsFileExists {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory)]
        [string]
        $Project,
        [Parameter(Mandatory)]
        [string]
        $Repository,
        [Parameter(Mandatory)]
        [string]
        $Path
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $Organization = $script:connection.Organization
    $header = $script:connection.GetHeader()
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
    Get GitHub Advanced Security (GHAS) data for a repository

    .DESCRIPTION
    Get GitHub Advanced Security (GHAS) data for a repository using Azure DevOps Rest API

    .PARAMETER ProjectId
    Project ID for Azure DevOps

    .PARAMETER Repository
    Repository name for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsRepositoryGhas -Project $Project -Repository $Repository
#>
Function Get-AzDevOpsRepositoryGhas {
    [CmdletBinding()]
    [OutputType([object])]
    param (
        [Parameter(Mandatory)]
        [string]
        $ProjectId,
        [Parameter(Mandatory)]
        [string]
        $RepositoryId
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $TokenType = $script:connection.TokenType
    $Organization = $script:connection.Organization
    # token is not FullAccess, write a warning and return null
    if ($TokenType -ne "FullAccess") {
        Write-Warning "The $TokenType token type does not have access to the Repositories API, returning null"
        return $null
    } else {
        $header = $script:connection.GetHeader()
        $payload = @{
            contributionIds = @(
                "ms.vss-features.my-organizations-data-provider"
                "ms.vss-advsec.advanced-security-enablement-data-provider"
            )
            dataProviderContext = @{
                properties = @{
                    givenProjectId = $ProjectId
                    givenRepoId = $RepositoryId
                }
            }
        }
        $url = "https://dev.azure.com/$Organization/_apis/Contribution/HierarchyQuery?api-version=5.0-preview.1"
        try {
            $response = Invoke-RestMethod -Uri $url -Method Post -Headers $header -Body ($payload | ConvertTo-Json) -ContentType "application/json"
            # If the response is a string and not an object, throw an exception for authentication failure or project not found
            if ($response -is [string]) {
                throw "Authentication failed or project not found"
            }
        }
        catch {
            throw $_.Exception.Message
        }
        return $response.dataProviders.'ms.vss-advsec.advanced-security-enablement-data-provider'
    }
}
Export-ModuleMember -Function Get-AzDevOpsRepositoryGhas
# End of Function Get-AzDevOpsRepositoryGhas

<#
    .SYNOPSIS
    Get and export all Azure DevOps repos in a project with default, main and master branches and branch policies and export to JSON with 1 file per repo

    .DESCRIPTION
    Get and export all Azure DevOps repos in a project with default, main and master branches and branch policies and export to JSON using Azure DevOps Rest API and this modules functions

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER OutputPath
    Output path for JSON file

    .PARAMETER PassThru
    Return the exported repos as objects to the pipeline instead of writing to a file

    .EXAMPLE
    Export-AzDevOpsReposAndBranchPolicies -Project $Project -OutputPath $OutputPath

    .NOTES
    This function returns an empty object if no branch policy is found for the branch
#>
function Export-AzDevOpsReposAndBranchPolicies {
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
    $TokenType = $script:connection.TokenType    
    $repos = Get-AzDevOpsRepos -Project $Project
    $repos | ForEach-Object {
        if ($null -ne $_) {
            $repo = $_
            # Add ObjectType Azure.DevOps.Repo to repo object
            $repo | Add-Member -MemberType NoteProperty -Name ObjectType -Value "Azure.DevOps.Repo"
            # Add ObjectName to repo object
            $repo | Add-Member -MemberType NoteProperty -Name ObjectName -Value ("{0}.{1}.{2}" -f $Organization,$Project,$repo.name)
            Write-Verbose "Getting branch policy for repo $($repo.name)"
            If($repo.defaultBranch) {
                $branchPolicy = Get-AzDevOpsBranchPolicy -Project $Project -Repository $repo.id -Branch $repo.defaultBranch
            }
            $repo | Add-Member -MemberType NoteProperty -Name MainBranchPolicy -Value $branchPolicy
            # Add a property indicating if a file named README.md or README exists in the repo
            $readmeExists = ((Test-AzDevOpsFileExists -Project $Project -Repository $repo.id -Path "README.md") -or (Test-AzDevOpsFileExists -Project $Project -Repository $repo.id -Path "README"))
            $repo | Add-Member -MemberType NoteProperty -Name ReadmeExists -Value $readmeExists

            # Get all branches for the repo
            $branches = Get-AzDevOpsBranches -Project $Project -Repository $repo.id
            # add branch policies for each branch to the branches object
            $branches = $branches | ForEach-Object {
                $branch = $_
                $branchPolicy = @(Get-AzDevOpsBranchPolicy -Project $Project -Repository $repo.id -Branch $branch.name)
                $branch | Add-Member -MemberType NoteProperty -Name BranchPolicy -Value $branchPolicy
                $branch
            }
            # Add an ObjectType Azure.DevOps.Repo.Branch to each branch object
            $branches = $branches | ForEach-Object {
                $branch = $_
                $branch | Add-Member -MemberType NoteProperty -Name ObjectType -Value "Azure.DevOps.Repo.Branch"
                # Add ObjectName to branch object
                $branch | Add-Member -MemberType NoteProperty -Name ObjectName -Value ("{0}.{1}.{2}.{3}" -f $Organization,$Project,$repo.name,$branch.name)
                $branch
            }



            # Add a property indicating if a file named LICENSE or LICENSE.md exists in the repo
            $licenseExists = ((Test-AzDevOpsFileExists -Project $Project -Repository $repo.id -Path "LICENSE") -or (Test-AzDevOpsFileExists -Project $Project -Repository $repo.id -Path "LICENSE.md"))
            $repo | Add-Member -MemberType NoteProperty -Name LicenseExists -Value $licenseExists

            # Add a property for GitHub Advanced Security (GHAS) data if the token type is FullAccess
            if ($TokenType -eq "FullAccess") {
                $ghas = Get-AzDevOpsRepositoryGhas -ProjectId $repo.project.id -RepositoryId $repo.id
                $repo | Add-Member -MemberType NoteProperty -Name Ghas -Value $ghas
            } else {
                Write-Warning "The $TokenType token type does not have access to the GHAS API, returning null"
            }
            
            # Add a property with pipeline permissions
            $pipelinePermissions = Get-AzDevOpsRepositoryPipelinePermissions -ProjectId $repo.project.id -RepositoryId $repo.id
            $repo | Add-Member -MemberType NoteProperty -Name PipelinePermissions -Value $pipelinePermissions
            $repo.id = @{ 
                originalId      = $repo.id;
                project         = $Project;
                organization    = $Organization
            } | ConvertTo-Json -Depth 100
            # Add a property with repo ACLs if the token type is not ReadOnly
            if ($TokenType -ne "ReadOnly") {
                $repoAcls = Get-AzDevOpsRepositoryAcls -ProjectId $repo.project.id -RepositoryId $repo.id
                $repo | Add-Member -MemberType NoteProperty -Name Acls -Value $repoAcls
            }
            $branches += $repo
            # If the PassThru switch is set, return the repo object
            if ($PassThru) {
                Write-Output $branches
            } else {
                # Export repo object to JSON file
                Write-Verbose "Exporting repo $($repo.name) and its branches to JSON as file $($repo.name).ado.repo.json"
                $branches | ConvertTo-Json -Depth 100 | Out-File -FilePath "$OutputPath\$($repo.name).ado.repo.json"
            }
        }
    }
}
Export-ModuleMember -Function Export-AzDevOpsReposAndBranchPolicies
# End of Function Export-AzDevOpsReposAndBranchPolicies
