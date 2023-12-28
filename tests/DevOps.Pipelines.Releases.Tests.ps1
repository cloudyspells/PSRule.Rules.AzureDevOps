BeforeAll {
    $rootPath = $PWD
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1') -Force
}

Describe "Functions: DevOps.Pipelines.Releases.Tests" {
    Context " Get-AzDevOpsReleaseDefinitions without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsReleaseDefinitions -Project $env:ADO_PROJECT
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsReleaseDefinitions on a project with release definitions" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $releaseDefinitions = Get-AzDevOpsReleaseDefinitions -Project $env:ADO_PROJECT
        }

        It " should return a list of release definitions" {
            $releaseDefinitions | Should -Not -BeNullOrEmpty
        }

        It " should return a list of release definitions that are of type PSObject" {
            $releaseDefinitions[0] | Should -BeOfType [PSCustomObject]
        }

        It " should return a list of release definitions that have a name" {
            $releaseDefinitions[0].name | Should -Not -BeNullOrEmpty
            $releaseDefinitions[0].name | Should -BeOfType [string]
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsReleaseDefinitions on a project without release definitions" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $releaseDefinitions = Get-AzDevOpsReleaseDefinitions -Project "empty-project"
        }

        It " should return null or empty list of release definitions" {
            $releaseDefinitions | Should -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsReleaseDefinitions with wrong parameters" {
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsReleaseDefinitions -Project $env:ADO_PROJECT } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsReleaseDefinitions -Project "wrong-project" } | Should -Throw
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsReleaseDefinitionAcls without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsReleaseDefinitionAcls -Project $env:ADO_PROJECT -ReleaseDefinitionId 2 -Folder ''
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsReleaseDefinitionAcls on a project with release definitions" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $releaseDefinitionAcls = Get-AzDevOpsReleaseDefinitionAcls -ProjectId $ProjectId -ReleaseDefinitionId 2 -Folder ''
        }

        It " should return a list of release definition acls" {
            $releaseDefinitionAcls | Should -Not -BeNullOrEmpty
        }

        It " should return a list of release definition acls that are of type PSObject" {
            $releaseDefinitionAcls[0] | Should -BeOfType [PSCustomObject]
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsReleaseDefinitionAcls with wrong parameters" {
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            { Get-AzDevOpsReleaseDefinitionAcls -ProjectId $ProjectId -ReleaseDefinitionId 2 -Folder '' } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsReleaseDefinitionAcls -ProjectId "wrong-project" -ReleaseDefinitionId 2 -Folder '' } | Should -Throw
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsReleaseDefinitionAcls with a ReadOnly Token" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_READONLY -TokenType ReadOnly
            $ProjectId = "1fa185aa-ce58-4732-8700-8964802ea538"
            $releaseDefinitionAcls = Get-AzDevOpsReleaseDefinitionAcls -ProjectId $ProjectId -ReleaseDefinitionId 2 -Folder '' -WarningVariable warning
        }

        It " should return null or empty list of release definition acls" {
            $releaseDefinitionAcls | Should -BeNullOrEmpty
        }

        It " should return a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Export-AzDevOpsReleaseDefinitions without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Export-AzDevOpsReleaseDefinitions -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Export-AzDevOpsReleaseDefinitions on a project with release definitions" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsReleaseDefinitions -Project $Project -OutputPath $OutputPath
        }

        It " should export files with an extension of .ado.rd.json" {
            $files = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter *.ado.rd.json
            $files | Should -Not -BeNullOrEmpty
        }

        It " should export files parseable as JSON" {
            $files = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter *.ado.rd.json
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json | Should -Not -BeNullOrEmpty
            }
        }

        It " should export objects that contain an ObjectType of Azure.DevOps.Releases.Definition" {
            $files = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter *.ado.rd.json
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json.ObjectType | Should -Be 'Azure.DevOps.Pipelines.Releases.Definition'
            }
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Export-AzDevOpsReleaseDefinitions -PassThru" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $Project = $env:ADO_PROJECT
            $releaseDefinitions = Export-AzDevOpsReleaseDefinitions -Project $Project -PassThru
            $ruleResult = $releaseDefinitions | Invoke-PSRule -Module @('PSRule.Rules.AzureDevOps') -Culture en
        }

        It " should return a list of release definitions" {
            $releaseDefinitions | Should -Not -BeNullOrEmpty
        }

        It " should return a list of release definitions that are of type PSObject" {
            $releaseDefinitions[0] | Should -BeOfType [PSCustomObject]
        }

        It " should return a list of release definitions that have an ObjectType" {
            $releaseDefinitions[0].ObjectType | Should -Not -BeNullOrEmpty
            $releaseDefinitions[0].ObjectType | Should -BeOfType [string]
        }

        It " should return a list of release definitions that have an ObjectName" {
            $releaseDefinitions[0].ObjectName | Should -Not -BeNullOrEmpty
            $releaseDefinitions[0].ObjectName | Should -BeOfType [string]
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