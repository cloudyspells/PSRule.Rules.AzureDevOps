BeforeAll {
    $rootPath = $PWD;
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1') -Force;
}

Describe "Azure.DevOps.Group" {
    Context " Get-AzDevOpsGroups" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $groups = Get-AzDevOpsGroups -Project $env:ADO_PROJECT
        }

        It " Should return a list of groups" {
            $groups | Should -Not -BeNullOrEmpty
        }

        It " Should return a list of groups with a display name" {
            $groups.displayName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsGroups with a ReadOnly PAT" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_READONLY
            $groups = Get-AzDevOpsGroups -Project $env:ADO_PROJECT
        }

        It " Should return a list of groups" {
            $groups | Should -Not -BeNullOrEmpty
        }

        It " Should return a list of groups with a display name" {
            $groups.displayName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsGroups with a FineGrained PAT" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_FINEGRAINED
            $groups = Get-AzDevOpsGroups -Project $env:ADO_PROJECT
        }

        It " Should return a list of groups" {
            $groups | Should -Not -BeNullOrEmpty
        }

        It " Should return a list of groups with a display name" {
            $groups.displayName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsGroups with wrong PAT or Organization" {
        It " Should throw an error with a wrong PAT" {
            { 
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrongPAT"
                Get-AzDevOpsGroups -Project $env:ADO_PROJECT
            } | Should -Throw
        }

        It " Should throw an error with a wrong Organization" {
            { 
                Connect-AzDevOps -Organization "wrongOrganization" -PAT $env:ADO_PAT
                Get-AzDevOpsGroups -Project $env:ADO_PROJECT
            } | Should -Throw
        }
    }

    
}
