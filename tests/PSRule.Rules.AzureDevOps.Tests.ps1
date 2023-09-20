BeforeAll {
    Import-Module -Name "$($env:GITHUB_WORKSPACE)/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psm1" -Force
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

    Context "When running Get-AzDevOpsBranchPolicy" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $repos = Get-AzDevOpsRepos -PAT $PAT -Organization $Organization -Project $Project
            $Repository = $repos[0].id
            $Branch = $repos[0].defaultBranch
            $branchPolicy = Get-AzDevOpsBranchPolicy -PAT $PAT -Organization $Organization -Project $Project -Repository $Repository -Branch $Branch
        }

        It 'Should return a branch policy' {
            $branchPolicy | Should -Not -BeNullOrEmpty
            $branchPolicy | Should -BeOfType [PSCustomObject]
            $branchPolicy._links.policyType.href | Should -Not -BeNullOrEmpty
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

    Context "When running Get-AzDevOpsArmServiceConnections" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $serviceConnections = Get-AzDevOpsArmServiceConnections -PAT $PAT -Organization $Organization -Project $Project
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

    Context "When running Get-AzDevOpsArmServiceConnectionChecks" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $serviceConnections = Get-AzDevOpsArmServiceConnections -PAT $PAT -Organization $Organization -Project $Project
            $serviceConnectionId = $serviceConnections[1].id
            $serviceConnectionChecks = Get-AzDevOpsArmServiceConnectionChecks -PAT $PAT -Organization $Organization -Project $Project -ServiceConnectionId $serviceConnectionId
        }

        It 'Should return a list of service connection checks' {
            $serviceConnectionChecks | Should -Not -BeNullOrEmpty
            $serviceConnectionChecks[0] | Should -BeOfType [PSCustomObject]
        }
    }

    Context "When running Export-AzDevOpsArmServiceConnections" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsArmServiceConnections -PAT $PAT -Organization $Organization -Project $Project -OutputPath $OutputPath
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

    Context "When running Get-AzDevOpsVariableGroups" {
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

    Context "When running Get-AzDevOpsPipelines" {
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

    Context "When running Get-AzDevOpsReleaseDefinitions" {
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

    Context "When running Get-AzDevOpsEnvironments" {
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

    Context "When running Get-AzDevOpsEnvironmentChecks" {
        BeforeAll {
            $PAT = $env:ADO_PAT
            $Organization = $env:ADO_ORGANIZATION
            $Project = $env:ADO_PROJECT

            $environments = Get-AzDevOpsEnvironments -PAT $PAT -Organization $Organization -Project $Project
            $environmentId = $environments[0].id
            $environmentChecks = Get-AzDevOpsEnvironmentChecks -PAT $PAT -Organization $Organization -Project $Project -Environment $environmentId
        }

        It 'Should return a list of environment checks' {
            $environmentChecks | Should -Not -BeNullOrEmpty
            $environmentChecks[0] | Should -BeOfType [PSCustomObject]
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

    Context 'When running Export-AzDevOpsRuleData' {
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
}
