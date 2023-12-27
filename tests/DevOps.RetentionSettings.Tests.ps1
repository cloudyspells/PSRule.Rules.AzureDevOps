BeforeAll {
    $rootPath = $PWD;
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1') -Force;
}

Describe 'Azure.DevOps.RetentionSettings' {
    Context ' Get-AzDevOpsRetentionSettings without a connection' {
        It 'should throw an error' {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsRetentionSettings -Project 'MyProject'
            } | Should -Throw 'Not connected to Azure DevOps. Run Connect-AzDevOps first.'
        }
    }

    Context ' Get-AzDevOpsRetentionSettings' {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $response = Get-AzDevOpsRetentionSettings -Project $env:ADO_PROJECT
        }

        It 'should return a hashtable' {
            $response | Should -BeOfType [hashtable]
        }

        It 'should return a hashtable with RetentionSettings property' {
            $response.RetentionSettings | Should -Not -BeNullOrEmpty
        }

        It 'should return a hashtable with RetentionPolicy property' {
            $response.RetentionPolicy | Should -Not -BeNullOrEmpty
        }

        It 'should return a hashtable with ObjectType property' {
            $response.ObjectType | Should -Not -BeNullOrEmpty
        }

        It 'should return a hashtable with ObjectName property' {
            $response.ObjectName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context ' Get-AzDevOpsRetentionSettings with a wrong organization or PAT' {
        It 'should throw an error with a wrong PAT' {
            { 
                Disconnect-AzDevOps
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT 'wrongPAT'
                Get-AzDevOpsRetentionSettings -Project $env:ADO_PROJECT
            } | Should -Throw "Failed to get retention settings for project '$($env:ADO_PROJECT)' from Azure DevOps"
        }

        It 'should throw an error with a wrong organization' {
            { 
                Disconnect-AzDevOps
                Connect-AzDevOps -Organization 'wrongOrganization' -PAT $env:ADO_PAT
                Get-AzDevOpsRetentionSettings -Project $env:ADO_PROJECT
            } | Should -Throw "Failed to get retention settings for project '$($env:ADO_PROJECT)' from Azure DevOps"
        }

        It 'should throw an error with a wrong project' {
            { 
                Disconnect-AzDevOps
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
                Get-AzDevOpsRetentionSettings -Project 'wrongProject'
            } | Should -Throw "Failed to get retention settings for project 'wrongProject' from Azure DevOps"
        }
    }

    Context ' Export-AzDevOpsRetentionSettings without a connection' {
        It 'should throw an error' {
            { 
                Disconnect-AzDevOps
                Export-AzDevOpsRetentionSettings -Project 'MyProject' -OutputPath 'C:\Temp\'
            } | Should -Throw 'Not connected to Azure DevOps. Run Connect-AzDevOps first.'
        }
    }

    Context ' Export-AzDevOpsRetentionSettings' {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            Export-AzDevOpsRetentionSettings -Project $env:ADO_PROJECT -OutputPath 'C:\Temp\'
        }

        It 'should export a JSON file' {
            $file = Get-ChildItem -Path 'C:\Temp\' -Filter "$($env:ADO_PROJECT).ret.ado.json" -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'FullName'
            $file | Should -Not -BeNullOrEmpty
        }

        It 'should export a JSON file with the correct name' {
            $file = Get-ChildItem -Path 'C:\Temp\' -Filter "$($env:ADO_PROJECT).ret.ado.json" -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'FullName'
            $file | Should -Match "$($env:ADO_PROJECT).ret.ado.json"
        }

        It 'should export a JSON file with the correct content' {
            $file = Get-ChildItem -Path 'C:\Temp\' -Filter "$($env:ADO_PROJECT).ret.ado.json" -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'FullName'
            $content = Get-Content -Path $file -Raw
            $content | Should -Match 'RetentionSettings'
            $content | Should -Match 'RetentionPolicy'
            $content | Should -Match 'ObjectType'
            $content | Should -Match 'ObjectName'
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context ' Export-AzDevOpsRetentionSettings with a wrong organization or PAT' {
        It 'should throw an error with a wrong PAT' {
            { 
                Disconnect-AzDevOps
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT 'wrongPAT'
                Export-AzDevOpsRetentionSettings -Project $env:ADO_PROJECT -OutputPath 'C:\Temp\'
            } | Should -Throw "Failed to get retention settings for project '$($env:ADO_PROJECT)' from Azure DevOps"
        }

        It 'should throw an error with a wrong organization' {
            { 
                Disconnect-AzDevOps
                Connect-AzDevOps -Organization 'wrongOrganization' -PAT $env:ADO_PAT
                Export-AzDevOpsRetentionSettings -Project $env:ADO_PROJECT -OutputPath 'C:\Temp\'
            } | Should -Throw "Failed to get retention settings for project '$($env:ADO_PROJECT)' from Azure DevOps"
        }

        It 'should throw an error with a wrong project' {
            { 
                Disconnect-AzDevOps
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
                Export-AzDevOpsRetentionSettings -Project 'wrongProject' -OutputPath 'C:\Temp\'
            } | Should -Throw "Failed to get retention settings for project 'wrongProject' from Azure DevOps"
        }
    }
}

AfterAll {
    Disconnect-AzDevOps
    Remove-Module -Name PSRule.Rules.AzureDevOps -Force
}