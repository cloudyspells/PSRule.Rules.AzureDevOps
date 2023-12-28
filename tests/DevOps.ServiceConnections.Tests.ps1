BeforeAll {
    $rootPath = $PWD;
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1') -Force;
}

Describe "Functions: DevOps.ServiceConnections.Tests" {
    Context " Get-AzDevOpsServiceConnections without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsServiceConnections -Project $env:ADO_PROJECT
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsServiceConnections" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $serviceConnections = Get-AzDevOpsServiceConnections -Project $env:ADO_PROJECT
        }

        It " should return a list of service connections" {
            $serviceConnections | Should -Not -BeNullOrEmpty
        }

        It " should return a list of service connections that are of type PSObject" {
            $serviceConnections[0] | Should -BeOfType [PSCustomObject]
        }

        It " should return a list of service connections that have a name" {
            $serviceConnections[0].name | Should -Not -BeNullOrEmpty
            $serviceConnections[0].name | Should -BeOfType [string]
        }
    }

    Context " Get-AzDevOpsServiceConnections with wrong parameters" {
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsServiceConnections -Project $env:ADO_PROJECT -ErrorAction Stop } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsServiceConnections -Project "wrong-project" -ErrorAction Stop } | Should -Throw
        }
    }

    Context "When running Get-AzDevOpsServiceConnectionChecks without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsServiceConnectionChecks -Project $env:ADO_PROJECT -ServiceConnectionId 1
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context "When running Get-AzDevOpsServiceConnectionChecks on a protected service connection" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $Project = $env:ADO_PROJECT
            $serviceConnections = Get-AzDevOpsServiceConnections -Project $Project
            $serviceConnectionId = $serviceConnections[1].id
            $serviceConnectionChecks = Get-AzDevOpsServiceConnectionChecks -Project $Project -ServiceConnectionId $serviceConnectionId
        }

        It " should return a list of service connection checks" {
            $serviceConnectionChecks | Should -Not -BeNullOrEmpty
        }

        It " should return a list of service connection checks that are of type PSObject" {
            $serviceConnectionChecks[0] | Should -BeOfType [PSCustomObject]
        }
    }

    Context "When running Get-AzDevOpsServiceConnectionChecks on a non-protected service connection" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $Project = $env:ADO_PROJECT
            $serviceConnections = Get-AzDevOpsServiceConnections -Project $Project
            $serviceConnectionId = $serviceConnections[0].id
            $serviceConnectionChecks = Get-AzDevOpsServiceConnectionChecks -Project $Project -ServiceConnectionId $serviceConnectionId
        }

        It " should be null or empty" {
            $serviceConnectionChecks | Should -BeNullOrEmpty
        }
    }

    Context "When running Get-AzDevOpsServiceConnectionChecks with wrong parameters" {
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsServiceConnectionChecks -Project $env:ADO_PROJECT -ServiceConnectionId 1 -ErrorAction Stop } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsServiceConnectionChecks -Project "wrong-project" -ServiceConnectionId 1 -ErrorAction Stop } | Should -Throw
        }
    }

    Context " Export-AzDevOpsServiceConnections without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Export-AzDevOpsServiceConnections -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Export-AzDevOpsServiceConnections" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $Project = $env:ADO_PROJECT
            $OutputPath = $env:ADO_EXPORT_DIR
            Export-AzDevOpsServiceConnections -Project $Project -OutputPath $OutputPath
        }

        It ' should export files with a .aso.sc.json extension' {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File -Filter "*.ado.sc.json"
            $files | Should -Not -BeNullOrEmpty
        }

        It " should export parsable JSON files" {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File -Filter "*.ado.sc.json"
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json | Should -Not -BeNullOrEmpty
            }
        }

        It ' should export all JSON files with an ObjectType property set to Azure.DevOps.ServiceConnection' {
            $files = Get-ChildItem -Path $OutputPath -Recurse -File | Where-Object { $_.Name -eq "ado.sc.json" }
            $files | ForEach-Object {
                $json = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
                $json.ObjectType | Should -Be "Azure.DevOps.ServiceConnection"
            }
        }
    }

    Context " Export-AzDevOpsServiceConnections -PassThru" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $Project = $env:ADO_PROJECT
            $serviceConnections = Export-AzDevOpsServiceConnections -Project $Project -PassThru
            $ruleResult = $serviceConnections | Invoke-PSRule -Module @('PSRule.Rules.AzureDevOps') -Culture en
        }

        It " should return a list of service connections" {
            $serviceConnections | Should -Not -BeNullOrEmpty
        }

        It " should return a list of service connections that are of type PSObject" {
            $serviceConnections[0] | Should -BeOfType [PSCustomObject]
        }

        It " should return a list of service connections that have an ObjectName" {
            $serviceConnections[0].ObjectName | Should -Not -BeNullOrEmpty
            $serviceConnections[0].ObjectName | Should -BeOfType [string]
        }

        It " should return a list of service connections that have an ObjectType" {
            $serviceConnections[0].ObjectType | Should -Not -BeNullOrEmpty
            $serviceConnections[0].ObjectType | Should -BeOfType [string]
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