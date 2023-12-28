BeforeAll {
    $rootPath = $PWD;
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1') -Force;
}

Describe "Functions: DevOps.Tasks.VariableGroups.Tests" {
    Context ' Get-AzDevOpsVariableGroups without a connection' {
        It ' should throw an error' {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsVariableGroups -Project $env:ADO_PROJECT
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsVariableGroups on a project containing variable groups" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $Project = $env:ADO_PROJECT
            $variableGroups = Get-AzDevOpsVariableGroups -Project $Project
        }

        It ' should return a list of variable groups' {
            $variableGroups | Should -Not -BeNullOrEmpty
        }

        It ' should return a list of variable groups that are of type PSObject' {
            $variableGroups[0] | Should -BeOfType [PSCustomObject]
        }

        It ' should return a list of variable groups with a name' {
            $variableGroups[0].name | Should -Not -BeNullOrEmpty
            $variableGroups[0].name | Should -BeOfType [System.String]
        }
    }

    Context ' Get-AzDevOpsVariableGroups on an empty project' {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $EmptyProject = 'empty-project'
            $variableGroups = Get-AzDevOpsVariableGroups -Project $EmptyProject
        }

        It ' should return null or empty' {
            $variableGroups | Should -BeNullOrEmpty
        }
    }

    Context ' Get-AzDevOpsVariableGroups with wrong parameters' {
        It ' should throw an error with a wrong PAT' {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT 'wrong-pat'
            { Get-AzDevOpsVariableGroups -Project $env:ADO_PROJECT -ErrorAction Stop } | Should -Throw
        }

        It ' should throw a 404 error with a wrong project and organization' {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsVariableGroups -Project 'wrong-project' -ErrorAction Stop } | Should -Throw
        }
    }

    Context " Export-AzDevOpsVariableGroups without a connection" {
        It ' should throw an error' {
            { 
                Disconnect-AzDevOps
                Export-AzDevOpsVariableGroups -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Export-AzDevOpsVariableGroups" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $Project = $env:ADO_PROJECT
            Export-AzDevOpsVariableGroups -Project $Project -OutputPath $env:ADO_EXPORT_DIR
        }

        It ' should export files with a .ado.vg.json extension' {
            $files = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Recurse -File -Filter "*.ado.vg.json"
            $files | Should -Not -BeNullOrEmpty
        }

        It ' should export parsable JSON files' {
            $files = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Recurse -Filter "*.ado.vg.json"
            $json = Get-Content -Path $files[0].FullName | ConvertFrom-Json -Depth 100
            $json | Should -Not -BeNullOrEmpty
        }

        It ' should export object with an ObjectType property set to Azure.DevOps.Tasks.VariableGroup' {
            $files = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Recurse -Filter "*.ado.vg.json"
            $json = Get-Content -Path $files[0].FullName | ConvertFrom-Json -Depth 100
            $json.ObjectType | Should -Be "Azure.DevOps.Tasks.VariableGroup"
        }
    }

    Context " Export-AzDevOpsVariableGroups -PassThru" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $Project = $env:ADO_PROJECT
            $variableGroups = Export-AzDevOpsVariableGroups -Project $Project -PassThru
            $ruleResult = $variableGroups | Invoke-PSRule -Module @('PSRule.Rules.AzureDevOps') -Culture en
        }

        It ' should return a list of variable groups' {
            $variableGroups | Should -Not -BeNullOrEmpty
        }

        It ' should return a list of variable groups that are of type PSObject' {
            $variableGroups[0] | Should -BeOfType [PSCustomObject]
        }

        It ' should return a list of variable groups with an ObjectName' {
            $variableGroups[0].ObjectName | Should -Not -BeNullOrEmpty
            $variableGroups[0].ObjectName | Should -BeOfType [System.String]
        }

        It ' should return a list of variable groups with an ObjectType' {
            $variableGroups[0].ObjectType | Should -Not -BeNullOrEmpty
            $variableGroups[0].ObjectType | Should -BeOfType [System.String]
        }

        It " The output should have results with Invoke-PSRule" {
            $ruleResult | Should -Not -BeNullOrEmpty
        }

        It " The output should have results with Invoke-PSRule that are of type [PSRule.Rules.RuleRecord]" {
            $ruleResult[0] | Should -BeOfType [PSRule.Rules.RuleRecord]
        }
    }
}

AfterAll {
    Disconnect-AzDevOps
    Remove-Module -Name PSRule.Rules.AzureDevOps -Force
}