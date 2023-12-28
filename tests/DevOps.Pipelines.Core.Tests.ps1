BeforeAll {
    $rootPath = $PWD;
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1') -Force;
}

Describe "Functions: DevOps.Pipelines.Core.Tests" {
    Context " Get-AzDevOpsPipelines without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsPipelines -Project $env:ADO_PROJECT
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }
    Context " Get-AzDevOpsPipelines on a project with pipelines" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $pipelines = Get-AzDevOpsPipelines -Project $env:ADO_PROJECT
        }

        It " should return a list of pipelines" {
            $pipelines | Should -Not -BeNullOrEmpty
        }

        It " should return a list of pipelines that are of type PSObject" {
            $pipelines[0] | Should -BeOfType [PSCustomObject]
        }

        It " should return a list of pipelines that have a name" {
            $pipelines[0].name | Should -Not -BeNullOrEmpty
            $pipelines[0].name | Should -BeOfType [string]
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsPipelines on a project without pipelines" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $pipelines = Get-AzDevOpsPipelines -Project "empty-project"
        }

        It " should return null or empty list of pipelines" {
            $pipelines | Should -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsPipelines with wrong parameters" {
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsPipelines -Project $env:ADO_PROJECT } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsPipelines -Project "wrong-project" } | Should -Throw
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsPipelineAcls without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsPipelineAcls -PipelineId 7 -ProjectId "1fa185aa-ce58-4732-8700-8964802ea538"
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsPipelineAcls on a project with pipelines" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $pipelineId = 7
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $pipelineAcls = Get-AzDevOpsPipelineAcls -PipelineId $PipelineId -ProjectId $ProjectId
        }

        It " should return a list of pipeline acls" {
            $pipelineAcls | Should -Not -BeNullOrEmpty
        }

        It " should return a list of pipeline acls that are of type PSObject" {
            $pipelineAcls[0] | Should -BeOfType [PSCustomObject]
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsPipelineAcls with wrong parameters" {
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsPipelineAcls -PipelineId 7 -ProjectId "1fa185aa-ce58-4732-8700-8964802ea538" } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsPipelineAcls -PipelineId 7 -ProjectId "this-is-wrong" } | Should -Throw
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsPipelineAcls with a ReadOnly PAT" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_READONLY -TokenType ReadOnly
            $pipelineId = 7
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $pipelineAcls = Get-AzDevOpsPipelineAcls -PipelineId $PipelineId -ProjectId $ProjectId -WarningVariable warning
        }

        It " should return a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }

        It " should be null or empty" {
            $pipelineAcls | Should -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsPipelineYaml without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsPipelineYaml -PipelineId 7 -Project $env:ADO_PROJECT
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsPipelineYaml on a pipeline with all defaults" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $pipelineId = 7
            $Project = $env:ADO_PROJECT
            $pipelineYaml = Get-AzDevOpsPipelineYaml -PipelineId $PipelineId -Project $Project
        }

        It " should return a pipeline yaml" {
            $pipelineYaml | Should -Not -BeNullOrEmpty
        }

        It " should return a string" {
            $pipelineYaml | Should -BeOfType [string]
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsPipelineYaml on a pipeline that need parameters" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $pipelineId = 10
            $Project = $env:ADO_PROJECT
            $pipelineYaml = Get-AzDevOpsPipelineYaml -PipelineId $PipelineId -Project $Project
        }

        It " should return a pipeline yaml" {
            $pipelineYaml | Should -Not -BeNullOrEmpty
        }

        It " should return a string" {
            $pipelineYaml | Should -BeOfType [string]
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsPipelineYaml with wrong parameters" {
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsPipelineYaml -PipelineId 7 -ProjectId "1fa185aa-ce58-4732-8700-8964802ea538" } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsPipelineYaml -PipelineId 7 -ProjectId "this-is-wrong" } | Should -Throw
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Export-AzDevOpsPipelineYaml without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Export-AzDevOpsPipelineYaml -PipelineId 7 -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR -PipelineName "psrule-success-project"
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Export-AzDevOpsPipelineYaml on a pipeline" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $pipelineId = 7
            $Project = $env:ADO_PROJECT
            Export-AzDevOpsPipelineYaml -PipelineId $PipelineId -Project $Project -OutputPath $env:ADO_EXPORT_DIR -PipelineName "psrule-success-project"
        }

        It " should export all pipeline yamls" {
            $pipelineYamls = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter *.yaml -Recurse
            $pipelineYamls | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Export-AzDevOpsPipelines without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Export-AzDevOpsPipelines -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Export-AzDevOpsPipelines on a project with pipelines" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            Export-AzDevOpsPipelines -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
        }

        It " should export all pipeline jsons" {
            $pipelineJsons = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter *.ado.pl.json -Recurse
            $pipelineJsons | Should -Not -BeNullOrEmpty
        }

        It " should export parseable JSON" {
            $pipelineJsons = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter *.ado.pl.json -Recurse
            $pipelineJsons | ForEach-Object {
                $pipelineJson = Get-Content -Path $_.FullName -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json
                $pipelineJson | Should -Not -BeNullOrEmpty
            }
        }

        It " should export JSON objects with an ObjectType field with a value of Azure.DevOps.Pipeline" {
            $pipelineJsons = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter *.ado.pl.json -Recurse
            $pipelineJsons | ForEach-Object {
                $pipelineJson = Get-Content -Path $_.FullName -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json
                $pipelineJson.ObjectType | Should -Be "Azure.DevOps.Pipeline"
            }
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Export-AzDevOpsPipelines -PassThru" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $pipelines = Export-AzDevOpsPipelines -Project $env:ADO_PROJECT -PassThru
            $ruleResult = $pipelines | Invoke-PSRule -Module @('PSRule.Rules.AzureDevOps') -Culture en
        }

        It " should return a list of pipelines" {
            $pipelines | Should -Not -BeNullOrEmpty
        }

        It " should return a list of pipelines that are of type PSObject" {
            $pipelines[1] | Should -BeOfType [PSCustomObject]
        }

        It " should return a list of pipelines that have an ObjectType field with a value of Azure.DevOps.Pipeline" {
            $pipelines[1].ObjectType | Should -Be "Azure.DevOps.Pipeline"
        }

        It " should return a list of pipelines that have an ObjectName field" {
            $pipelines[1].ObjectName | Should -Not -BeNullOrEmpty
        }

        It " The output should have results with Invoke-PSRule" {
            $ruleResult | Should -Not -BeNullOrEmpty
        }

        It " The output should have results with Invoke-PSRule that are of type [PSRule.Rules.RuleRecord]" {
            $ruleResult[0] | Should -BeOfType [PSRule.Rules.RuleRecord]
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    
    }
}

AfterAll {
    Disconnect-AzDevOps
    Remove-Module -Name PSRule.Rules.AzureDevOps -Force
}