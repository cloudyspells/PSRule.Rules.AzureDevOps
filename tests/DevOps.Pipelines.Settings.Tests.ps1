BeforeAll {
    $rootPath = $PWD;
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1') -Force;
}

Describe "Functions: DevOps.Pipelines.Settings.Tests" {
    Context " Get-AzDevOpsPipelinesSettings without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsPipelinesSettings -Project $env:ADO_PROJECT
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }
    Context " Get-AzDevOpsPipelinesSettings on a project with pipelines" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $settings = Get-AzDevOpsPipelinesSettings -Project $env:ADO_PROJECT
        }

        It " should return project pipeline settings" {
            $settings | Should -Not -BeNullOrEmpty
        }

        It " should return project pipeline settings that are of type PSObject" {
            $settings | Should -BeOfType [PSCustomObject]
        }
    }

    Context " Get-AzDevOpsPipelinesSettings with wrong parameters" {
        It " should throw an error with a wrong PAT" {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrong-pat"
            { Get-AzDevOpsPipelinesSettings -Project $env:ADO_PROJECT -ErrorAction Stop } | Should -Throw
        }

        It " should throw a 404 error with a wrong project and organization" {
            Connect-AzDevOps -Organization 'wrong-org' -PAT $env:ADO_PAT
            { Get-AzDevOpsPipelinesSettings -Project "wrong-project" -ErrorAction Stop } | Should -Throw
        }
    }

    Context " Export-AzDevOpsPipelinesSettings without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Export-AzDevOpsPipelinesSettings -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Export-AzDevOpsPipelinesSettings" {        
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            Export-AzDevOpsPipelinesSettings -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
        }

        It " should export the pipeline settings to a .ado.pls.json file" {
            $file = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter '*.ado.pls.json' -Recurse
            $file | Should -Not -BeNullOrEmpty
        }

        It " should export the pipeline settings as parsable JSON" {
            $file = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter '*.ado.pls.json' -Recurse
            $json = Get-Content -Path $file.FullName -Raw | ConvertFrom-Json
            $json | Should -Not -BeNullOrEmpty
        }

        It " should export an object with an ObjectType of Azure.DevOps.Pipelines.Settings" {
            $file = Get-ChildItem -Path $env:ADO_EXPORT_DIR -Filter '*.ado.pls.json' -Recurse | Select-Object -First 1
            $json = Get-Content -Path $file.FullName -Raw | ConvertFrom-Json
            $json.ObjectType | Should -Be "Azure.DevOps.Pipelines.Settings"
        }
    }
}

AfterAll {
    Disconnect-AzDevOps
    Remove-Module -Name PSRule.Rules.AzureDevOps -Force;
}
