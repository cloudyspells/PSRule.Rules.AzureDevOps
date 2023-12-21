BeforeAll {
    $rootPath = $PWD;
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1') -Force;
}

Describe "Functions: DevOps.Repos.Tests" {
    Context " Get-AzDevOpsRepos without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsRepos -Project $env:ADO_PROJECT
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsRepos on a project" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $repos = Get-AzDevOpsRepos -Project $env:ADO_PROJECT
        }

        It " should return a list of repos" {
            $repos | Should -Not -BeNullOrEmpty
        }

        It " should return a list of repos that are of type PSObject" {
            $repos[0] | Should -BeOfType [PSCustomObject]
        }

        It " should return a list of repos that have a name" {
            $repos[0].name | Should -Not -BeNullOrEmpty
            $repos[0].name | Should -BeOfType [string]
        }

        It " should return a list of repos that have a default branch" {
            $repos[0].defaultBranch | Should -Not -BeNullOrEmpty
            $repos[0].defaultBranch | Should -BeOfType [string]
        }
    }

    Context " Get-AzDevOpsRepos with wrong parameters" {
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsRepos -Project $env:ADO_PROJECT -ErrorAction Stop } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsRepos -Project "wrong-project" -ErrorAction Stop } | Should -Throw
        }
    }

    Context " Get-AzDevOpsBranches without a connection" {
        It " should throw an error" {
            { 
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
                $repos = Get-AzDevOpsRepos -Project $env:ADO_PROJECT
                Disconnect-AzDevOps
                Get-AzDevOpsBranches -Project $env:ADO_PROJECT -Repository $repos[0].id
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsBranches on a project" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $repos = Get-AzDevOpsRepos -Project $env:ADO_PROJECT
            $branches = Get-AzDevOpsBranches -Project $env:ADO_PROJECT -Repository $repos[0].id
        }

        It " should return a list of branches" {
            $branches | Should -Not -BeNullOrEmpty
        }
    }

    Context " Get-AzDevOpsBranches with wrong parameters" {
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsBranches -Project $env:ADO_PROJECT -ErrorAction Stop } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsBranches -Project "wrong-project" -ErrorAction Stop } | Should -Throw
        }
    }

    Context " Get-AzDevOpsBranchPolicy without a connection" {
        It " should throw an error" {
            { 
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
                $repos = Get-AzDevOpsRepos -Project $env:ADO_PROJECT
                $repository = $repos[1].id
                $Branch = $repos[1].defaultBranch
                Disconnect-AzDevOps
                Get-AzDevOpsBranchPolicy -Project $env:ADO_PROJECT -Repository $repository -Branch $Branch
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsBranchPolicy on a protected branch" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $repos = Get-AzDevOpsRepos -Project $env:ADO_PROJECT
            $repository = $repos[1].id
            $Branch = $repos[1].defaultBranch
            $policy = Get-AzDevOpsBranchPolicy -Project $env:ADO_PROJECT -Repository $repository -Branch $Branch
        }

        It " should return a branch policy" {
            $policy | Should -Not -BeNullOrEmpty
        }

        It " should return a branch policy that is of type PSObject" {
            $policy | Should -BeOfType [PSCustomObject]
        }

        It " should have a policyType href" {
            $policy._links.policyType.href | Should -Not -BeNullOrEmpty
        }
    }

    Context " Get-AzDevOpsBranchPolicy on a non-protected branch" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $repos = Get-AzDevOpsRepos -Project $env:ADO_PROJECT
            $repository = $repos[0].id
            $Branch = $repos[0].defaultBranch
            $policy = Get-AzDevOpsBranchPolicy -Project $env:ADO_PROJECT -Repository $repository -Branch $Branch
        }

        It " should return null or empty branch policy" {
            $policy | Should -BeNullOrEmpty
        }
    }

    Context " Get-AzDevOpsBranchPolicy with wrong parameters" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $repos = Get-AzDevOpsRepos -Project $env:ADO_PROJECT
            $repository = $repos[0].id
            $Branch = $repos[0].defaultBranch
            Disconnect-AzDevOps
        }
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsBranchPolicy -Project $env:ADO_PROJECT -Repository $repository -Branch $Branch -ErrorAction Stop } | Should -Throw
        }

        It " should throw a 404 error with a wrong project" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            { Get-AzDevOpsBranchPolicy -Project "wrong-project" -Repository $repository -Branch $Branch -ErrorAction Stop } | Should -Throw
        }
    }

    Context " Get-AzDevOpsRepositoryAcls without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsRepositoryAcls -RepositoryId 7 -ProjectId "1fa185aa-ce58-4732-8700-8964802ea538"
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsRepositoryAcls" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repos = Get-AzDevOpsRepos -Project $env:ADO_PROJECT
            $RepositoryId = ($repos | Where-Object { $_.name -eq 'repository-success'})[0].id
            $repositoryAcls = Get-AzDevOpsRepositoryAcls -RepositoryId $RepositoryId -ProjectId $ProjectId
        }

        It " should return a list of acls" {
            $repositoryAcls | Should -Not -BeNullOrEmpty
        }

        It " should return a list of acls that are of type PSObject" {
            $repositoryAcls[0] | Should -BeOfType [PSCustomObject]
        }
    }

    Context " Get-AzDevOpsRepositoryAcls with wrong parameters" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repos = Get-AzDevOpsRepos -Project $env:ADO_PROJECT
            $RepositoryId = ($repos | Where-Object { $_.name -eq 'repository-success'})[0].id
            Disconnect-AzDevOps
        }
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsRepositoryAcls -RepositoryId $RepositoryId -ProjectId $ProjectId -ErrorAction Stop } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsRepositoryAcls -RepositoryId $RepositoryId -ProjectId $ProjectId -ErrorAction Stop } | Should -Throw
        }
    }

    Context " Get-AzDevOpsRepositoryAcls with a ReadOnly TokenType" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_READONLY -TokenType ReadOnly
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repos = Get-AzDevOpsRepos -Project $env:ADO_PROJECT
            $RepositoryId = ($repos | Where-Object { $_.name -eq 'repository-success'})[0].id
            $repositoryAcls = Get-AzDevOpsRepositoryAcls -RepositoryId $RepositoryId -ProjectId $ProjectId -WarningVariable warning
        }

        It " should return null or empty" {
            $repositoryAcls | Should -BeNullOrEmpty
        }

        It " should return a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }
    }

    Context " Test-AzDevOpsFileExists without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Test-AzDevOpsFileExists -Repository psrule-fail-project  -Project $env:ADO_PROJECT -Path "README.md"
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Test-AzDevOpsFileExists" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repos = Get-AzDevOpsRepos -Project $env:ADO_PROJECT
            $RepositoryId = ($repos | Where-Object { $_.name -eq 'repository-success'})[0].id
            $fileExists = Test-AzDevOpsFileExists -Repository $RepositoryId -Project $env:ADO_PROJECT -Path "README.md"
        }

        It " should return true" {
            $fileExists | Should -Be $true
        }
    }

    Context " Get-AzDevOpsRepositoryGhas without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsRepositoryGhas -RepositoryId 7 -ProjectId "1fa185aa-ce58-4732-8700-8964802ea538"
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsRepositoryGhas" {
        It " should return a [PSCustomObject]" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repoId = "befaaf13-3966-45c0-b481-6387e860d915"
            $repositoryGhas = Get-AzDevOpsRepositoryGhas -RepositoryId $repoId -ProjectId $ProjectId
            $repositoryGhas | Should -BeOfType [PSCustomObject]
        }
    }

    Context " Get-AzDevOpsRepositoryGhas with wrong parameters" {
        BeforeAll {
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repoId = "befaaf13-3966-45c0-b481-6387e860d915"
        }

        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsRepositoryGhas -RepositoryId $repoId -ProjectId $ProjectId -ErrorAction Stop } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsRepositoryGhas -RepositoryId $repoId -ProjectId $ProjectId -ErrorAction Stop } | Should -Throw
        }
    }

    Context " Get-AzDevOpsRepositoryGhas with a FineGrained TokenType" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_FINEGRAINED -TokenType FineGrained
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repoId = "befaaf13-3966-45c0-b481-6387e860d915"
            $repositoryGhas = Get-AzDevOpsRepositoryGhas -RepositoryId $repoId -ProjectId $ProjectId -WarningVariable warning
        }

        It " should return null or empty" {
            $repositoryGhas | Should -BeNullOrEmpty
        }

        It " should return a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }
    }

    Context " Get-AzDevOpsRepositoryPipelinePermissions without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsRepositoryPipelinePermissions -RepositoryId "befaaf13-3966-45c0-b481-6387e860d915" -ProjectId "1fa185aa-ce58-4732-8700-8964802ea538"
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        } 
    }

    Context ' Get-AzDevOpsRepositoryPipelinePermissions' {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repositoryName = 'repository-success'
            $repoId = "befaaf13-3966-45c0-b481-6387e860d915"
            $repoPipelinePermissions = Get-AzDevOpsRepositoryPipelinePermissions `
                -ProjectId $ProjectId `
                -RepositoryId "befaaf13-3966-45c0-b481-6387e860d915"
        }

        It ' should return an object' {
            $repoPipelinePermissions | Should -Not -BeNullOrEmpty
            $repoPipelinePermissions | Should -BeOfType [PSCustomObject]
        }
    }

    Context " Get-AzDevOpsRepositoryPipelinePermissions with wrong parameters" {
        BeforeAll {
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repoId = "befaaf13-3966-45c0-b481-6387e860d915"
        }

        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsRepositoryPipelinePermissions -RepositoryId $repoId -ProjectId $ProjectId -ErrorAction Stop } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsRepositoryPipelinePermissions -RepositoryId $repoId -ProjectId $ProjectId -ErrorAction Stop } | Should -Throw
        }
    }

    Context " Export-AzDevOpsReposAndBranchPolicies without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Export-AzDevOpsReposAndBranchPolicies -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Export-AzDevOpsReposAndBranchPolicies" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsReposAndBranchPolicies -Project $Project -OutputPath $OutputPath
        }

        It ' should export files with an ado.repo.json extension' {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File -Filter *.ado.repo.json
            $files | Should -Not -BeNullOrEmpty
        }

        It ' should export parsable JSON files' {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File -Filter *.ado.repo.json
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should export all JSON files with an Azure.DevOps.Repo ObjectType object in it' {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File | Where-Object { $_.Name -match "ado.repo.json" }
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json | Where-Object { $_.ObjectType -eq "Azure.DevOps.Repo" } | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should export all JSON files with an Azure.DevOps.Repo.Branch ObjectType object in it' {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File | Where-Object { $_.Name -match "ado.repo.json" }
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json | Where-Object { $_.ObjectType -eq "Azure.DevOps.Repo.Branch" } | Should -Not -BeNullOrEmpty
            }
        }
    }
}

AfterAll {
    Disconnect-AzDevOps
    Remove-Module -Name PSRule.Rules.AzureDevOps -Force
}   