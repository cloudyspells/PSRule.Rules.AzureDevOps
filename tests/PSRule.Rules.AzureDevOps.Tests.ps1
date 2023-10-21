BeforeAll {
    $rootPath = $PWD;
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1') -Force;
}

Describe 'PSRule.Rules.AzureDevOps' {
    Context "When running Get-AzDevOpsHeader" {
        It 'Should return a header' {
            $PAT = $env:ADO_PAT
            $header = Get-AzDevOpsHeader -PAT $PAT
            $header | Should -Not -BeNullOrEmpty
        }

        It "Should return a base64 encoded Authorization header" {
            $PAT = $env:ADO_PAT
            $header = Get-AzDevOpsHeader -PAT $PAT
            $header.Authorization | Should -Not -BeNullOrEmpty
            $header.Authorization | Should -Match 'Basic'
        }
    }

    Context "When running Get-AzDevOpsProjects" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $projects = Get-AzDevOpsProjects -PAT $PAT -Organization $Organization
        }

        It 'Should return a list of projects' {
            $projects | Should -Not -BeNullOrEmpty
            $projects[0] | Should -BeOfType [PSCustomObject]
        }

        It 'Should return a list of projects with a name' {
            $projects[0].name | Should -Not -BeNullOrEmpty
            $projects[0].name | Should -BeOfType [System.String]
        }

        It 'Should throw an error with a non-existing Organization' {
            $faultyOrganization = "faultyOrganization"
            { Get-AzDevOpsProjects -PAT $PAT -Organization $faultyOrganization -ErrorAction SilentlyContinue } | Should -Throw
        }
    }

    Context "When running Get-AzDevOpsProjects with a wrong PAT" {
        BeforeAll {
            $PAT = 'ThisIsAFaultyPAT'
            $Organization = $env:ADO_ORGANIZATION
        }

        It 'Should throw an error' {
            { Get-AzDevOpsProjects -PAT $PAT -Organization $Organization -ErrorAction Stop } | Should -Throw
        }
    }

    Context "When running Get-AzDevOpsProjects with a ReadOnly PAT" {
        BeforeAll {
            $PAT = $env:ADO_PAT_READONLY
            $Organization = $env:ADO_ORGANIZATION
            $projects = Get-AzDevOpsProjects -PAT $PAT -Organization $Organization -TokenType ReadOnly
        }

        It 'Should return a list of projects' {
            $projects | Should -Not -BeNullOrEmpty
            $projects[0] | Should -BeOfType [PSCustomObject]
        }

        It 'Should return a list of projects with a name' {
            $projects[0].name | Should -Not -BeNullOrEmpty
            $projects[0].name | Should -BeOfType [System.String]
        }
    }

    Context "When running Get-AzDevOpsProjects with a FineGrained PAT" {
        BeforeAll {
            $PAT = $env:ADO_PAT_FINEGRAINED
            $Organization = $env:ADO_ORGANIZATION
            $projects = Get-AzDevOpsProjects -PAT $PAT -Organization $Organization -TokenType FineGrained
        }

        It 'Should return a list of projects' {
            $projects | Should -Not -BeNullOrEmpty
            $projects[0] | Should -BeOfType [PSCustomObject]
        }

        It 'Should return a list of projects with a name' {
            $projects[0].name | Should -Not -BeNullOrEmpty
            $projects[0].name | Should -BeOfType [System.String]
        }
    }

    Context "When running Get-AzDevOpsRepos" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $repos = Get-AzDevOpsRepos -PAT $PAT -Organization $Organization -Project $Project
        }

        It 'Should return a list of repos' {
            $repos | Should -Not -BeNullOrEmpty
            $repos[0] | Should -BeOfType [PSCustomObject]
        }

        It 'Should return a list of repos with a default branch' {
            $repos[0].defaultBranch | Should -Not -BeNullOrEmpty
            $repos[0].defaultBranch | Should -BeOfType [System.String]
        }
    }

    Context "When running Get-AzDevOpsRepos with a wrong project name and faulty PAT" {
        BeforeAll {
            $PAT = 'ThisIsAFaultyPAT'
            $Organization = $env:ADO_ORGANIZATION
            $FaultyProject = 'faulty-project'
        }

        It 'Should throw an error' {
            { Get-AzDevOpsRepos -PAT $PAT -Organization $Organization -Project $FaultyProject -ErrorAction Stop } | Should -Throw
        }
    }

    Context "When running Get-AzDevOpsBranchPolicy on a protected branch" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $repos = Get-AzDevOpsRepos -PAT $PAT -Organization $Organization -Project $Project
            $Repository = $repos[1].id
            $Branch = $repos[1].defaultBranch
            $branchPolicy = Get-AzDevOpsBranchPolicy -PAT $PAT -Organization $Organization -Project $Project -Repository $Repository -Branch $Branch
        }

        It 'Should return a branch policy' {
            $branchPolicy | Should -Not -BeNullOrEmpty
            $branchPolicy | Should -BeOfType [PSCustomObject]
            $branchPolicy._links.policyType.href | Should -Not -BeNullOrEmpty
        }
    }

    Context "When running Get-AzDevOpsBranchPolicy on an unprotected branch" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $repos = Get-AzDevOpsRepos -PAT $PAT -Organization $Organization -Project $Project
            $Repository = $repos[0].id
            $Branch = $repos[0].defaultBranch
            $branchPolicy = Get-AzDevOpsBranchPolicy -PAT $PAT -Organization $Organization -Project $Project -Repository $Repository -Branch $Branch
        }

        It 'Should return null or empty' {
            $branchPolicy | Should -BeNullOrEmpty
        }
    }

    Context "When running Get-AzDevOpsBranchPolicy with a wrong project name and faulty PAT" {
        BeforeAll {
            $PAT = 'ThisIsAFaultyPAT'
            $Organization = $env:ADO_ORGANIZATION
            $FaultyProject = 'faulty-project'
            $Repository = 'faulty-repository'
            $Branch = 'faulty-branch'
        }

        It 'Should throw an error' {
            { Get-AzDevOpsBranchPolicy -PAT $PAT -Organization $Organization -Project $FaultyProject -Repository $Repository -Branch $Branch -ErrorAction Stop } | Should -Throw
        }
    }

    Context 'When running Get-AzDevOpsRepositoryAcls' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repos = Get-AzDevOpsRepos -PAT $PAT -Organization $Organization -Project $Project
            $RepositoryId = ($repos | Where-Object { $_.name -eq 'repository-success'})[0].id
            $repositoryAcls = Get-AzDevOpsRepositoryAcls -PAT $PAT -Organization $Organization -RepositoryId $RepositoryId -ProjectId $ProjectId
        }

        It 'Should return a list of repository acls' {
            $repositoryAcls | Should -Not -BeNullOrEmpty
            $repositoryAcls[0] | Should -BeOfType [PSCustomObject]
        }
    }

    Context 'When running Get-AzDevOpsRepositoryAcls with wrong parameters' {
        It 'Should throw an 404 error when all parameters are wrong' {
            { Get-AzDevOpsRepositoryAcls -PAT 'FaultyPAT' -ProjectId 'wrongId' -Organization 'faulty-org' -RepositoryId 'FaultyRepositoryId' -ErrorAction Stop } | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        }

        It 'Should throw a authentication error when the PAT is wrong' {
            { Get-AzDevOpsRepositoryAcls -PAT 'FaultyPAT' -ProjectId "1fa185aa-ce58-4732-8700-8964802ea538" -Organization $env:ADO_ORGANIZATION -RepositoryId 'FaultyRepositoryId' -ErrorAction Stop } | Should -Throw "Authentication failed or project not found"
        }
    }

    Context 'When running Get-AzDevOpsRepositoryAcls with a ReadOnly PAT' {
        BeforeAll {
            $PAT = $env:ADO_PAT_READONLY
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repos = Get-AzDevOpsRepos -PAT $PAT -TokenType ReadOnly -Organization $Organization -Project $Project
            $RepositoryId = ($repos | Where-Object { $_.name -eq 'repository-success'})[0].id
            $repositoryAcls = Get-AzDevOpsRepositoryAcls -PAT $PAT -TokenType ReadOnly -Organization $Organization -RepositoryId $RepositoryId -ProjectId $ProjectId -WarningVariable warning
        }

        It "Should write a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }

        It 'Should return null or empty' {
            $repositoryAcls | Should -BeNullOrEmpty
        }
    }

    Context "When running Test-AzDevOpsFileExists" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $repos = Get-AzDevOpsRepos -PAT $PAT -Organization $Organization -Project $Project
            $Repository = $repos[0].id
            $Path = "README.md"
            $fileExists = Test-AzDevOpsFileExists -PAT $PAT -Organization $Organization -Project $Project -Repository $Repository -Path $Path
        }

        It 'Should return a boolean' {
            $fileExists | Should -Not -BeNullOrEmpty
            $fileExists | Should -BeOfType [System.Boolean]
        }
    }

    Context 'When running Get-AzDevOpsRepositoryGhas' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repositoryName = 'repository-success'
            $repoId = "befaaf13-3966-45c0-b481-6387e860d915"
            $repoGhas = Get-AzDevOpsRepositoryGhas -PAT $PAT `
                -Organization $Organization `
                -ProjectId $ProjectId `
                -RepositoryId "befaaf13-3966-45c0-b481-6387e860d915"
        }

        It 'Should return an object' {
            $repoGhas | Should -Not -BeNullOrEmpty
            $repoGhas | Should -BeOfType [PSCustomObject]
        }
    }

    Context 'When running Get-AzDevOpsRepositoryGhas with all wrong parameters' {
        It 'Should return an error' {
            { 
                $PAT = 'FaultyPAT'
                $Organization = $env:ADO_ORGANIZATION
                $Project = 'project-success'
                $ProjectId = '1fa185aa-ce58-4732-8700-8964802ea538'
                $repositoryName = 'non-existent'
                $RepositoryId = 'non-existent'
                Get-AzDevOpsRepositoryGhas -PAT $PAT -Organization $Organization -ProjectId $ProjectId -RepositoryId $RepositoryId
            } | Should -Throw "Authentication failed or project not found"
        }
    }

    Context 'When running Get-AzDevOpsRepositoryGhas with a FineGrained PAT' {
        BeforeAll {
            $PAT = $env:ADO_PAT_FINEGRAINED
            $Organization = $env:ADO_ORGANIZATION
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repositoryName = 'repository-success'
            $repoId = "befaaf13-3966-45c0-b481-6387e860d915"
            $repoGhas = Get-AzDevOpsRepositoryGhas -PAT $PAT -TokenType FineGrained `
                -Organization $Organization `
                -ProjectId $ProjectId `
                -RepositoryId "befaaf13-3966-45c0-b481-6387e860d915" `
                -WarningVariable warning
        }

        It "Should write a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }

        It 'Should return null or empty' {
            $repoGhas | Should -BeNullOrEmpty
        }
    }

    Context 'When running Get-AzDevOpsRepositoryPipelinePermissions' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $repositoryName = 'repository-success'
            $repoId = "befaaf13-3966-45c0-b481-6387e860d915"
            $repoPipelinePermissions = Get-AzDevOpsRepositoryPipelinePermissions -PAT $PAT `
                -Organization $Organization `
                -ProjectId $ProjectId `
                -RepositoryId "befaaf13-3966-45c0-b481-6387e860d915"
        }

        It 'Should return an object' {
            $repoPipelinePermissions | Should -Not -BeNullOrEmpty
            $repoPipelinePermissions | Should -BeOfType [PSCustomObject]
        }
    }

    Context 'When running Get-AzDevOpsRepositoryPipelinePermissions with wrong parameters' {
        It 'Should return a 404 when all parameters are wrong' {
            $PAT = 'FaultyPAT'
            $Organization = 'faultyOrg'
            $ProjectId = 'faultyProject'
            $RepositoryId = 'faultyRepository'
            { Get-AzDevOpsRepositoryPipelinePermissions -PAT $PAT -Organization $Organization -ProjectId $ProjectId -RepositoryId $RepositoryId -ErrorAction Stop } | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        }

        It 'Should throw an authentication error if the PAT is wrong' {
            $PAT = 'FaultyPAT'
            $Organization = $env:ADO_ORGANIZATION
            $ProjectId = '1fa185aa-ce58-4732-8700-8964802ea538'
            $RepositoryId = 'befaaf13-3966-45c0-b481-6387e860d915'
            { Get-AzDevOpsRepositoryPipelinePermissions -PAT $PAT -Organization $Organization -ProjectId $ProjectId -RepositoryId $RepositoryId -ErrorAction Stop } | Should -Throw "Authentication failed or project not found"
        }
    }

    Context "When running Export-AzDevOpsReposAndBranchPolicies" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsReposAndBranchPolicies -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
        }

        It 'Should export all JSON files' {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File
            $files | Should -Not -BeNullOrEmpty
        }

        It 'Should export all JSON files with an ObjectType property set to Azure.DevOps.Repo' {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File | Where-Object { $_.Name -eq "ado.repo.json" }
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json.ObjectType | Should -Be "Azure.DevOps.Repo"
            }
        }
    }

    Context "When running Get-AzDevOpsServiceConnections" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $serviceConnections = Get-AzDevOpsServiceConnections -PAT $PAT -Organization $Organization -Project $Project
        }

        It 'Should return a list of service connections' {
            $serviceConnections | Should -Not -BeNullOrEmpty
            $serviceConnections[0] | Should -BeOfType [PSCustomObject]
        }

        It 'Should return a list of service connections with a name' {
            $serviceConnections[0].name | Should -Not -BeNullOrEmpty
            $serviceConnections[0].name | Should -BeOfType [System.String]
        }
    }

    Context "When running Get-AzDevOpsServiceConnections with a wrong project name and faulty PAT" {
        BeforeAll {
            $PAT = 'ThisIsAFaultyPAT'
            $Organization = $env:ADO_ORGANIZATION
            $FaultyProject = 'faulty-project'
        }

        It 'Should throw an error' {
            { Get-AzDevOpsServiceConnections -PAT $PAT -Organization $Organization -Project $FaultyProject -ErrorAction Stop } | Should -Throw
        }
    }

    Context "When running Get-AzDevOpsServiceConnectionChecks on a protected service connection" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $serviceConnections = Get-AzDevOpsServiceConnections -PAT $PAT -Organization $Organization -Project $Project
            $serviceConnectionId = $serviceConnections[1].id
            $serviceConnectionChecks = Get-AzDevOpsServiceConnectionChecks -PAT $PAT -Organization $Organization -Project $Project -ServiceConnectionId $serviceConnectionId
        }

        It 'Should return a list of service connection checks' {
            $serviceConnectionChecks | Should -Not -BeNullOrEmpty
            $serviceConnectionChecks[0] | Should -BeOfType [PSCustomObject]
        }
    }

    Context 'When running Get-AzDevOpsServiceConnectionChecks on an unprotected service connection' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT

            $serviceConnections = Get-AzDevOpsServiceConnections -PAT $PAT -Organization $Organization -Project $Project
            $serviceConnectionId = $serviceConnections[0].id
            $serviceConnectionChecks = Get-AzDevOpsServiceConnectionChecks -PAT $PAT -Organization $Organization -Project $Project -ServiceConnectionId $serviceConnectionId
        }

        It 'Should return null or empty' {
            $serviceConnectionChecks | Should -BeNullOrEmpty
        }
    }

    Context 'When running Get-AzDevOpsServiceConnectionChecks with wrong parameters' {
        It 'Should throw an 404 error when all parameters are wrong' {
            { Get-AzDevOpsServiceConnectionChecks -PAT 'FaultyPAT' -Organization 'faulty-org' -Project 'FaultyProject' -ServiceConnectionId 'FaultyServiceConnectionId' -ErrorAction Stop } | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        }

        It 'Should throw a authentication error when the PAT is wrong' {
            { Get-AzDevOpsServiceConnectionChecks -PAT 'FaultyPAT' -Organization $env:ADO_ORGANIZATION -Project $env:ADO_PROJECT -ServiceConnectionId 'FaultyServiceConnectionId' -ErrorAction Stop } | Should -Throw "Authentication failed or project not found"
        }
    }

    Context "When running Export-AzDevOpsServiceConnections" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsServiceConnections -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
        }

        It 'Should export all JSON files' {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File
            $files | Should -Not -BeNullOrEmpty
        }

        It 'Should export all JSON files with an ObjectType property set to Azure.DevOps.ServiceConnection' {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File | Where-Object { $_.Name -eq "ado.sc.json" }
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json.ObjectType | Should -Be "Azure.DevOps.ServiceConnection"
            }
        }
    }

    Context "When running Get-AzDevOpsVariableGroups on a project containing variable groups" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $variableGroups = Get-AzDevOpsVariableGroups -PAT $PAT -Organization $Organization -Project $Project
        }

        It 'Should return a list of variable groups' {
            $variableGroups | Should -Not -BeNullOrEmpty
            $variableGroups[0] | Should -BeOfType [PSCustomObject]
        }

        It 'Should return a list of variable groups with a name' {
            $variableGroups[0].name | Should -Not -BeNullOrEmpty
            $variableGroups[0].name | Should -BeOfType [System.String]
        }
    }

    Context 'When running Get-AzDevOpsVariableGroups on an empty project' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $EmptyProject = 'empty-project'
            $variableGroups = Get-AzDevOpsVariableGroups -PAT $PAT -Organization $Organization -Project $EmptyProject
        }

        It 'Should return null or empty' {
            $variableGroups | Should -BeNullOrEmpty
        }
    }

    Context 'When running Get-AzDevOpsVariableGroups with wrong parameters' {
        It 'Should throw an 404 error when all parameters are wrong' {
            { Get-AzDevOpsVariableGroups -PAT 'FaultyPAT' -Organization 'faulty-org' -Project 'FaultyProject' -ErrorAction Stop } | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        }

        It 'Should throw a authentication error when the PAT is wrong' {
            { Get-AzDevOpsVariableGroups -PAT 'FaultyPAT' -Organization $env:ADO_ORGANIZATION -Project $env:ADO_PROJECT -ErrorAction Stop } | Should -Throw "Authentication failed or project not found"
        }
    }

    Context "When running Export-AzDevOpsVariableGroups" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsVariableGroups -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
        }

        It 'Should export all JSON files' {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File
            $files | Should -Not -BeNullOrEmpty
        }

        It 'Should export all JSON files with an ObjectType property set to Azure.DevOps.Tasks.VariableGroup' {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File | Where-Object { $_.Name -eq "ado.vg.json" }
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json.ObjectType | Should -Be "Azure.DevOps.Tasks.VariableGroup"
            }
        }
    }

    Context "When running Get-AzDevOpsPipelines on a project containing pipelines" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $pipelines = Get-AzDevOpsPipelines -PAT $PAT -Organization $Organization -Project $Project
        }

        It 'Should return a list of pipelines' {
            $pipelines | Should -Not -BeNullOrEmpty
            $pipelines[0] | Should -BeOfType [PSCustomObject]
        }

        It 'Should return a list of pipelines with a name' {
            $pipelines[0].name | Should -Not -BeNullOrEmpty
            $pipelines[0].name | Should -BeOfType [System.String]
        }
    }

    Context 'When running Get-AzDevOpsPipelines on an empty project' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $EmptyProject = 'empty-project'
            $pipelines = Get-AzDevOpsPipelines -PAT $PAT -Organization $Organization -Project $EmptyProject
        }

        It 'Should return null or empty' {
            $pipelines | Should -BeNullOrEmpty
        }
    }

    Context 'When running Get-AzDevOpsPipelines with wrong parameters' {
        It 'Should throw an 404 error when all parameters are wrong' {
            { Get-AzDevOpsPipelines -PAT 'FaultyPAT' -Organization 'faulty-org' -Project 'FaultyProject' -ErrorAction Stop } | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        }

        It 'Should throw a authentication error when the PAT is wrong' {
            { Get-AzDevOpsPipelines -PAT 'FaultyPAT' -Organization $env:ADO_ORGANIZATION -Project $env:ADO_PROJECT -ErrorAction Stop } | Should -Throw "Authentication failed or project not found"
        }
    }

    Context 'When running Get-AzDevOpsPipelineAcls' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $pipelineId = 7
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $pipelineAcls = Get-AzDevOpsPipelineAcls -PAT $PAT -Organization $Organization -PipelineId $PipelineId -ProjectId $ProjectId
        }

        It 'Should return a list of pipeline acls' {
            $pipelineAcls | Should -Not -BeNullOrEmpty
            $pipelineAcls[0] | Should -BeOfType [PSCustomObject]
        }
    }

    Context 'When running Get-AzDevOpsPipelineAcls with wrong parameters' {
        It 'Should throw an 404 error when all parameters are wrong' {
            { Get-AzDevOpsPipelineAcls -PAT 'FaultyPAT' -Organization 'faulty-org' -ProjectId 'faulty-prj-id' -PipelineId 'FaultyPipelineId' -ErrorAction Stop } | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        }

        It 'Should throw a authentication error when the PAT is wrong' {
            { Get-AzDevOpsPipelineAcls -PAT 'FaultyPAT' -Organization $env:ADO_ORGANIZATION -ProjectId "1fa185aa-ce58-4732-8700-8964802ea538" -PipelineId 'FaultyPipelineId' -ErrorAction Stop } | Should -Throw "Authentication failed or project not found"
        }
    }

    Context 'When running Get-AzDevOpsPipelineAcls with a ReadOnly PAT' {
        BeforeAll {
            $PAT = $env:ADO_PAT_READONLY
            $Organization = $env:ADO_ORGANIZATION
            $pipelineId = 7
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $pipelineAcls = Get-AzDevOpsPipelineAcls -PAT $PAT -TokenType ReadOnly -Organization $Organization -PipelineId $PipelineId -ProjectId $ProjectId -WarningVariable warning
        }

        It "Should write a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }

        It 'Should return null or empty' {
            $pipelineAcls | Should -BeNullOrEmpty
        }
    }

    Context 'When running Get-AzDevOpsPipelineYaml with a pipeline with all defaults' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $PipelineId = '7'
            $yaml = Get-AzDevOpsPipelineYaml -PAT $PAT -Organization $Organization -Project $Project -PipelineId $PipelineId
        }

        It 'Should return a string' {
            $yaml | Should -Not -BeNullOrEmpty
            $yaml | Should -BeOfType [System.String]
        }
    }

    Context 'When running Get-AzDevOpsPipelineYaml with a pipeline that needs parameters' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $PipelineId = '10'
            $yaml = Get-AzDevOpsPipelineYaml -PAT $PAT -Organization $Organization -Project $Project -PipelineId $PipelineId
        }

        It 'Should return a string' {
            $yaml | Should -Not -BeNullOrEmpty
            $yaml | Should -BeOfType [System.String]
        }
    }

    Context 'When running Get-AzDevOpsPipelineYaml all wrong parameters' {
        It 'Should throw an error' {
            { 
                $PAT = 'FaultyPAT'
                $Organization = 'faulty-org'
                $Project = 'project-success'
                $PipelineId = '10'
                Get-AzDevOpsPipelineYaml -PAT $PAT -Organization $Organization -Project $Project -PipelineId $PipelineId
            } | Should -Throw
        }
    }

    Context "When running Export-AzDevOpsPipelines" {
        It 'Should export all JSON files with an ObjectType property set as Azure.DevOps.Pipeline' {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsPipelines -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
            $files = Get-ChildItem -Path $OutputPath -Recurse -File | Where-Object { $_.Name -eq "ado.pl.json" }
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json.ObjectType | Should -Be "Azure.DevOps.Pipeline"
            }
        }
    }

    Context 'When running Get-AzDevOpsPipelinesSettings' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $pipelinesSettings = Get-AzDevOpsPipelinesSettings -PAT $PAT -Organization $Organization -Project $Project
        }

        It 'Should return pipeline settings' {
            $pipelinesSettings | Should -Not -BeNullOrEmpty
            $pipelinesSettings | Should -BeOfType [PSCustomObject]
        }
    }

    Context 'When running Get-AzDevOpsPipelinesSettings with all wrong parameters' {
        It 'Should throw an error' {
            { 
                $PAT = 'FaultyPAT'
                $Organization = $env:ADO_ORGANIZATION
                $Project = 'project-success'
                Get-AzDevOpsPipelinesSettings -PAT $PAT -Organization $Organization -Project $Project 
            } | Should -Throw "Authentication failed or pipeline not found"
        }
    }

    Context 'When running Export-AzDevOpsPipelinesSettings' {
        It 'Should export all JSON files with an ObjectType property set as Azure.DevOps.Pipelines.Settings' {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsPipelinesSettings -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
            $files = Get-ChildItem -Path $OutputPath -Recurse -File | Where-Object { $_.Name -eq "ado.pls.json" }
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json.ObjectType | Should -Be "Azure.DevOps.Pipelines.Settings"
            }
        }
    }

    Context "When running Get-AzDevOpsReleaseDefinitions on a project containing release definitions" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $releaseDefinitions = Get-AzDevOpsReleaseDefinitions -PAT $PAT -Organization $Organization -Project $Project
        }

        It 'Should return a list of release definitions' {
            $releaseDefinitions | Should -Not -BeNullOrEmpty
            $releaseDefinitions[0] | Should -BeOfType [PSCustomObject]
        }

        It 'Should return a list of release definitions with a name' {
            $releaseDefinitions[0].name | Should -Not -BeNullOrEmpty
            $releaseDefinitions[0].name | Should -BeOfType [System.String]
        }
    }

    Context 'When running Get-AzDevOpsReleaseDefinitions on an empty project' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $EmptyProject = 'empty-project'
            $releaseDefinitions = Get-AzDevOpsReleaseDefinitions -PAT $PAT -Organization $Organization -Project $EmptyProject
        }

        It 'Should return null or empty' {
            $releaseDefinitions | Should -BeNullOrEmpty
        }
    }

    Context 'When running Get-AzDevOpsReleaseDefinitions with wrong parameters' {
        It 'Should throw an 404 error when all parameters are wrong' {
            { Get-AzDevOpsReleaseDefinitions -PAT 'FaultyPAT' -Organization 'faulty-org' -Project 'FaultyProject' -ErrorAction Stop } | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        }

        It 'Should throw a authentication error when the PAT is wrong' {
            { Get-AzDevOpsReleaseDefinitions -PAT 'FaultyPAT' -Organization $env:ADO_ORGANIZATION -Project $env:ADO_PROJECT -ErrorAction Stop } | Should -Throw "Authentication failed or project not found"
        }
    }

    Context "When running Get-AzDevOpsReleaseDefinitionAcls" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $releaseDefinitionId = 2
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $releaseDefinitionAcls = Get-AzDevOpsReleaseDefinitionAcls -PAT $PAT -Organization $Organization -ReleaseDefinitionId $releaseDefinitionId -ProjectId $ProjectId -Folder ''
        }

        It 'Should return a list of release definition acls' {
            $releaseDefinitionAcls | Should -Not -BeNullOrEmpty
            $releaseDefinitionAcls[0] | Should -BeOfType [PSCustomObject]
        }
    }

    Context 'When running Get-AzDevOpsReleaseDefinitionAcls with wrong parameters' {
        It 'Should throw an 404 error when all parameters are wrong' {
            { Get-AzDevOpsReleaseDefinitionAcls -PAT 'FaultyPAT' -Organization 'faulty-org' -ProjectId 'faulty' -ReleaseDefinitionId 99999 -Folder '' -ErrorAction Stop} | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        }

        It 'Should throw a authentication error when the PAT is wrong' {
            { Get-AzDevOpsReleaseDefinitionAcls -PAT 'FaultyPAT' -Organization $env:ADO_ORGANIZATION -ProjectId 'faulty' -ReleaseDefinitionId 99999 -Folder '\notexist' -ErrorAction Stop } | Should -Throw "Authentication failed or project not found"
        }
    }

    Context "When running Get-AzDevOpsReleaseDefinitionAcls with a ReadOnly PAT" {
        BeforeAll {
            $PAT = $env:ADO_PAT_READONLY
            $Organization = $env:ADO_ORGANIZATION
            $releaseDefinitionId = 2
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $releaseDefinitionAcls = Get-AzDevOpsReleaseDefinitionAcls -PAT $PAT -TokenType ReadOnly -Organization $Organization -ReleaseDefinitionId $releaseDefinitionId -ProjectId $ProjectId -Folder '' -WarningVariable warning
        }

        It "Should write a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }

        It 'Should return null or empty' {
            $releaseDefinitionAcls | Should -BeNullOrEmpty
        }
    }

    Context "When running Export-AzDevOpsReleaseDefinitions" {
        It 'Should export all JSON files with an ObjectType property set as Azure.DevOps.Releases.Definition' {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsReleaseDefinitions -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
            $files = Get-ChildItem -Path $OutputPath -Recurse -File | Where-Object { $_.Name -eq "ado.rd.json" }
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json.ObjectType | Should -Be "Azure.DevOps.Releases.Definition"
            }
        }
    }

    Context "When running Get-AzDevOpsEnvironments on a project containing environments" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
        }

        It 'Should return a list of environments' {
            $environments = Get-AzDevOpsEnvironments -PAT $PAT -Organization $Organization -Project $Project
            $environments | Should -Not -BeNullOrEmpty
            $environments[0] | Should -BeOfType [PSCustomObject]
        }

        It 'Should return a list of environments with a name' {
            $environments = Get-AzDevOpsEnvironments -PAT $PAT -Organization $Organization -Project $Project
            $environments[0].name | Should -Not -BeNullOrEmpty
            $environments[0].name | Should -BeOfType [System.String]
        }
    }

    Context 'When running Get-AzDevOpsEnvironments on an empty project' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $EmptyProject = 'empty-project'
            $environments = Get-AzDevOpsEnvironments -PAT $PAT -Organization $Organization -Project $EmptyProject
        }

        It 'Should return null or empty' {
            $environments | Should -BeNullOrEmpty
        }
    }

    Context 'When running Get-AzDevOpsEnvironments with wrong parameters' {
        It 'Should throw an 404 error when all parameters are wrong' {
            { Get-AzDevOpsEnvironments -PAT 'FaultyPAT' -Organization 'faulty-org' -Project 'FaultyProject' -ErrorAction Stop } | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        }

        It 'Should throw a authentication error when the PAT is wrong' {
            { Get-AzDevOpsEnvironments -PAT 'FaultyPAT' -Organization $env:ADO_ORGANIZATION -Project $env:ADO_PROJECT -ErrorAction Stop } | Should -Throw "Authentication failed or project not found"
        }
    }

    Context 'When running Get-AzDevOpsEnvironments with a ReadOnly PAT' {
        BeforeAll {
            $PAT = $env:ADO_PAT_READONLY
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $environments = Get-AzDevOpsEnvironments -PAT $PAT -TokenType ReadOnly -Organization $Organization -Project $Project -WarningVariable warning
        }

        It "Should write a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }

        It 'Should return null or empty' {
            $environments | Should -BeNullOrEmpty
        }
    }

    Context "When running Get-AzDevOpsEnvironmentChecks on a protected environment" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT

            $environments = Get-AzDevOpsEnvironments -PAT $PAT -Organization $Organization -Project $Project
            $environmentId = $environments[1].id
            $environmentChecks = Get-AzDevOpsEnvironmentChecks -PAT $PAT -Organization $Organization -Project $Project -Environment $environmentId
        }

        It 'Should return a list of environment checks' {
            $environmentChecks | Should -Not -BeNullOrEmpty
            $environmentChecks[0] | Should -BeOfType [PSCustomObject]
        }
    }

    Context 'When running Get-AzDevOpsEnvironmentChecks on an unprotected environment' {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT

            $environments = Get-AzDevOpsEnvironments -PAT $PAT -Organization $Organization -Project $Project
            $environmentId = $environments[0].id
            $environmentChecks = Get-AzDevOpsEnvironmentChecks -PAT $PAT -Organization $Organization -Project $Project -Environment $environmentId
        }

        It 'Should return null or empty' {
            $environmentChecks | Should -BeNullOrEmpty
        }
    }

    Context 'When running Get-AzDevOpsEnvironmentChecks with wrong parameters' {
        It 'Should throw an 404 error when all parameters are wrong' {
            { Get-AzDevOpsEnvironmentChecks -PAT 'FaultyPAT' -Organization 'faulty-org' -Project 'FaultyProject' -Environment 'faulty-environment' -ErrorAction Stop } | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        }

        It 'Should throw a authentication error when the PAT is wrong' {
            { Get-AzDevOpsEnvironmentChecks -PAT 'FaultyPAT' -Organization $env:ADO_ORGANIZATION -Project $env:ADO_PROJECT -Environment 'faulty-environment' -ErrorAction Stop } | Should -Throw "Authentication failed or project not found"
        }
    }

    Context 'When running Get-AzDevOpsEnvironmentChecks with a ReadOnly PAT' {
        BeforeAll {
            $PAT = $env:ADO_PAT_READONLY
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $environments = Get-AzDevOpsEnvironments -PAT $PAT -TokenType ReadOnly -Organization $Organization -Project $Project
            $environmentId = 7
            $environmentChecks = Get-AzDevOpsEnvironmentChecks -PAT $PAT -TokenType ReadOnly -Organization $Organization -Project $Project -Environment $environmentId -WarningVariable warning
        }

        It "Should write a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }

        It 'Should return null or empty' {
            $environmentChecks | Should -BeNullOrEmpty
        }
    }

    Context "When running Export-AzDevOpsEnvironmentChecks" {
        It 'Should export all JSON files with an ObjectType property set as Azure.DevOps.Pipelines.Environment' {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsEnvironmentChecks -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
            $files = Get-ChildItem -Path $OutputPath -Recurse -File | Where-Object { $_.Name -eq "ado.env.json" }
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json.ObjectType | Should -Be "Azure.DevOps.Pipelines.Environment"
            }
        }
    }

    Context 'When running Export-AzDevOpsRuleData with a Full Access PAT' {
        It 'Should export all JSON files' {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsRuleData -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
            $files = Get-ChildItem -Path $OutputPath -Recurse -File
            $files | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When running Export-AzDevOpsRuleData with a ReadOnly PAT' {
        BeforeAll {
            $PAT = $env:ADO_PAT_READONLY
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsRuleData -PAT $PAT -TokenType ReadOnly -Organization $Organization -Project $Project -OutputPath $OutputPath -WarningVariable warning
        }

        It "Should write warnings" {
            $warning | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When running Export-AzDevOpsRuleData with a FineGrained PAT' {
        BeforeAll {
            $PAT = $env:ADO_PAT_FINEGRAINED
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsRuleData -PAT $PAT -TokenType FineGrained -Organization $Organization -Project $Project -OutputPath $OutputPath -WarningVariable warning
        }

        It "Should write a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When running Export-AzDevOpsOrganizationRuleData' {
        
        It 'Should export all JSON files' {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $OutputPath = "$env:ADO_EXPORT_DIR/organization"
            # Create the output directory if it does not exist
            if (!(Test-Path -Path $OutputPath)) {
                New-Item -Path $OutputPath -ItemType Directory
            }
            Export-AzDevOpsOrganizationRuleData -PAT $PAT -Organization $Organization -OutputPath $OutputPath
            $files = Get-ChildItem -Path "$OutputPath" -Recurse -File
            $files | Should -Not -BeNullOrEmpty
        }
    }
}
