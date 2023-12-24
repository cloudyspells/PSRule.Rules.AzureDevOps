BeforeAll {
    $rootPath = $PWD;
    Import-Module -Name (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1') -Force;
}

Describe "Azure.DevOps.Group" {
    Context " Get-AzDevOpsGroups without a connection" {
        It " Should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsGroups -Project $env:ADO_PROJECT
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first."
        }
    }

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

    Context " Get-AzDevOpsGroupDetails without a connection" {
        It " Should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsGroupDetails -Group "TestGroup"
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first."
        }
    }

    Context " Get-AzDevOpsGroupDetails with a connection" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $group = Get-AzDevOpsGroups -Project $env:ADO_PROJECT | Where-Object { $_.displayName -eq "Project Administrators" }
            $groupDetails = Get-AzDevOpsGroupDetails -Group $group
        }

        It " Should return a group" {
            $groupDetails | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with a display name" {
            $groupDetails.displayName | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with members" {
            $groupDetails.members | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with members with a display name" {
            $groupDetails.members[0].displayName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsGroupDetails with a ReadOnly PAT" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_READONLY
            $group = Get-AzDevOpsGroups -Project $env:ADO_PROJECT | Where-Object { $_.displayName -eq "Project Administrators" }
            $groupDetails = Get-AzDevOpsGroupDetails -Group $group
        }

        It " Should return a group" {
            $groupDetails | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with a display name" {
            $groupDetails.displayName | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with members" {
            $groupDetails.members | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with members with a display name" {
            $groupDetails.members[0].displayName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsGroupDetails with a FineGrained PAT" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_FINEGRAINED
            $group = Get-AzDevOpsGroups -Project $env:ADO_PROJECT | Where-Object { $_.displayName -eq "Project Administrators" }
            $groupDetails = Get-AzDevOpsGroupDetails -Group $group
        }

        It " Should return a group" {
            $groupDetails | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with a display name" {
            $groupDetails.displayName | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with members" {
            $groupDetails.members | Should -Not -BeNullOrEmpty
        }

        It " Should return a group with members with a display name" {
            $groupDetails.members[0].displayName | Should -Not -BeNullOrEmpty
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }

    Context " Get-AzDevOpsGroupDetails with wrong PAT or Organization" {
        It " Should throw an error with a wrong PAT" {
            { 
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
                $group = Get-AzDevOpsGroups -Project $env:ADO_PROJECT | Where-Object { $_.displayName -eq "Project Administrators" }
                Disconnect-AzDevOps
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT "wrongPAT"
                Get-AzDevOpsGroupDetails -Group $group
            } | Should -Throw "Failed to get group memberOf details from Azure DevOps"
        }
    }

    Context " Get-AzDevOpsGroupDetails with a groups object containing bad links" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $group = Get-AzDevOpsGroups -Project $env:ADO_PROJECT | Where-Object { $_.displayName -eq "Project Administrators" }
        }

        It " Should throw an error with a bad link for memberships" {
            { 
                $group._links.memberships.href = "https://dev.azure.com/organization/project/_apis/graph/groups/00000000-0000-0000-0000-000000000000?api-version=6.0-preview.1"
                Get-AzDevOpsGroupDetails -Group $group
            } | Should -Throw "Failed to get group memberOf details from Azure DevOps"
        }

        AfterAll {
            Disconnect-AzDevOps
        }
    }
}
