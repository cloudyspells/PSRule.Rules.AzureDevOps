BeforeAll {
    $rootPath = $PWD
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1') -Force
}

Describe "Functions: Azure.DevOps.Pipelines.Environments.Tests" {
    Context " Get-AzDevOpsEnvironments without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsEnvironments -Project $env:ADO_PROJECT
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsEnvironments on a project with environments" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $environments = Get-AzDevOpsEnvironments -Project $env:ADO_PROJECT
        }

        It " should return a list of environments" {
            $environments | Should -Not -BeNullOrEmpty
        }

        It " should return a list of environments that are of type PSObject" {
            $environments[0] | Should -BeOfType [PSCustomObject]
        }

        It " should return a list of environments that have a name" {
            $environments[0].name | Should -Not -BeNullOrEmpty
            $environments[0].name | Should -BeOfType [string]
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsEnvironments on a project without environments" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $environments = Get-AzDevOpsEnvironments -Project "empty-project"
        }

        It " should return null or empty list of environments" {
            $environments | Should -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsEnvironments with wrong parameters" {
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsEnvironments -Project $env:ADO_PROJECT } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsEnvironments -Project "wrong-project" } | Should -Throw
        }
    }

    Context " Get-AzDevOpsEnvironments with a ReadOnly token" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_READONLY -TokenType ReadOnly
            $environments = Get-AzDevOpsEnvironments -Project $env:ADO_PROJECT -WarningVariable warning
        }

        It " should return null or empty list of environments" {
            $environments | Should -BeNullOrEmpty
        }

        It " should return a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsEnvironmentChecks without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsEnvironmentChecks -Project $env:ADO_PROJECT -Environment "test"
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsEnvironmentChecks on a protected environment" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $environments = Get-AzDevOpsEnvironments -Project $env:ADO_PROJECT
            $environmentId = $environments[1].id
            $environmentChecks = Get-AzDevOpsEnvironmentChecks -Project $env:ADO_PROJECT -Environment $environmentId
        }

        It " should return a list of environment checks" {
            $environmentChecks | Should -Not -BeNullOrEmpty
        }

        It " should return a list of environment checks that are of type PSObject" {
            $environmentChecks[0] | Should -BeOfType [PSCustomObject]
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsEnvironmentChecks on a non-protected environment" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $environments = Get-AzDevOpsEnvironments -Project $env:ADO_PROJECT
            $environmentId = $environments[0].id
            $environmentChecks = Get-AzDevOpsEnvironmentChecks -Project $env:ADO_PROJECT -Environment $environmentId
        }

        It " should return null or empty list of environment checks" {
            $environmentChecks | Should -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsEnvironmentChecks with wrong parameters" {
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsEnvironmentChecks -Project $env:ADO_PROJECT -Environment "test" } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsEnvironmentChecks -Project "wrong-project" -Environment "test" } | Should -Throw
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsEnvironmentChecks with a ReadOnly token" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $environments = Get-AzDevOpsEnvironments -Project $env:ADO_PROJECT
            $environmentId = $environments[1].id
            Disconnect-AzDevOps
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_READONLY -TokenType ReadOnly
            $environmentChecks = Get-AzDevOpsEnvironmentChecks -Project $env:ADO_PROJECT -Environment $environmentId -WarningVariable warning
        }

        It " should return null or empty list of environment checks" {
            $environmentChecks | Should -BeNullOrEmpty
        }

        It " should return a warning" {
            $warning | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Export-AzDevOpsEnvironmentChecks without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Export-AzDevOpsEnvironmentChecks -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Export-AzDevOpsEnvironmentChecks on a protected environment" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $environments = Get-AzDevOpsEnvironments -Project $env:ADO_PROJECT
            Export-AzDevOpsEnvironmentChecks -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
        }

        It " should export .ado.env.json files" {
            $files = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter "*.ado.env.json"
            $files | Should -Not -BeNullOrEmpty
        }

        It " should export parseable JSON" {
            $files = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter "*.ado.env.json"
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json | Should -Not -BeNullOrEmpty
            }
        }

        It " should export Objects with an ObjectType field set to Azure.DevOps.Pipelines.Environment" {
            $files = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter "*.ado.env.json"
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json.ObjectType | Should -Be "Azure.DevOps.Pipelines.Environment"
            }
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
# End of tests/DevOps.Pipelines.Environments.Tests.ps1