using module ../src/PSRule.Rules.AzureDevOps/PSRule.Rules.AzureDevOps.psd1
BeforeAll {
    # Dot source the Common.ps1 script
    . "$PSScriptRoot/../src/PSRule.Rules.AzureDevOps/Functions/Common.ps1"
}

Describe "Functions: Common.Tests" {
    Context " Connect-AzDevOps with a Personal Access Token" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $connection = $script:connection
        }

        It " The connection should not be null" {
            $connection | Should -Not -BeNullOrEmpty
        }

        # It " The connection should be of type AzureDevOpsConnection" {
        #     $connection | Should -BeOfType [AzureDevOpsConnection]
        # }

        It " The connection should have a token" {
            $connection.Token | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token that expires in the future" {
            $connection.TokenExpires | Should -BeGreaterThan (Get-Date)
        }

        It " should run Get-AzDevOpsProject" {
            $projects = Get-AzDevOpsProject
            $projects | Should -Not -BeNullOrEmpty
        }
    }

    Context " Connect-AzDevOps with a Service Principal" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -ClientId $env:ADO_CLIENT_ID -ClientSecret $env:ADO_CLIENT_SECRET -TenantId $env:ADO_TENANT_ID -AuthType ServicePrincipal
            $connection = $script:connection
        }

        It " The connection should not be null" {
            $connection | Should -Not -BeNullOrEmpty
        }

        # It " The connection should be of type AzureDevOpsConnection" {
        #     $connection | Should -BeOfType [AzureDevOpsConnection]
        # }

        It " The connection should have a token" {
            $connection.Token | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token that expires in the future" {
            $connection.TokenExpires | Should -BeGreaterThan (Get-Date)
        }

        It " should run Get-AzDevOpsProject" {
            $projects = Get-AzDevOpsProject
            $projects | Should -Not -BeNullOrEmpty
        }
    }

    Context " Connect-AzDevOps with a Service Principal and an expired token" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -ClientId $env:ADO_CLIENT_ID -ClientSecret $env:ADO_CLIENT_SECRET -TenantId $env:ADO_TENANT_ID -AuthType ServicePrincipal
            $script:connection.TokenExpires = [System.DateTime]::MinValue
            $projects = Get-AzDevOpsProject
            $connection = $script:connection
        }

        It " The connection should not be null" {
            $connection | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token" {
            $connection.Token | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token that expires in the future" {
            $connection.TokenExpires | Should -BeGreaterThan (Get-Date)
        }

        It " should run Get-AzDevOpsProject" {
            $projects | Should -Not -BeNullOrEmpty
        }
    }

    Context " Connect-AzDevOps with a Service Principal and a wrong secret" {
        It " The operation should fail with a wrong secret" {
            { 
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -ClientId $env:ADO_CLIENT_ID -ClientSecret 'wrong' -TenantId $env:ADO_TENANT_ID -AuthType ServicePrincipal
            } | Should -Throw 
        }
    }

    Context " Connect-AzDevOps with a User Assigned Managed Identity" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -AuthType ManagedIdentity
            $connection = $script:connection
        }

        It " The connection should not be null" {
            $connection | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token" {
            $connection.Token | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token that expires in the future" {
            $connection.TokenExpires | Should -BeGreaterThan (Get-Date)
        }

        It " should run Get-AzDevOpsProject" {
            $projects = Get-AzDevOpsProject
            $projects | Should -Not -BeNullOrEmpty
        }
    }

    Context " Connect-AzDevOps with a User Assigned Managed Identity and an expired token" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -AuthType ManagedIdentity
            $script:connection.TokenExpires = [System.DateTime]::MinValue
            $projects = Get-AzDevOpsProject
            $connection = $script:connection
        }

        It " The connection should not be null" {
            $connection | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token" {
            $connection.Token | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token that expires in the future" {
            $connection.TokenExpires | Should -BeGreaterThan (Get-Date)
        }

        It " should run Get-AzDevOpsProject" {
            $projects | Should -Not -BeNullOrEmpty
        }
    }

    Context " Connect-AzDevOps with a System Assigned Managed Identity" {
        BeforeAll {
            Remove-Item Env:\ADO_MSI_CLIENT_ID
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -AuthType ManagedIdentity
            $connection = $script:connection
        }

        It " The connection should not be null" {
            $connection | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token" {
            $connection.Token | Should -Not -BeNullOrEmpty
        }

        It " The connection should have a token that expires in the future" {
            $connection.TokenExpires | Should -BeGreaterThan (Get-Date)
        }
    }
    
    Context " Disconnect-AzDevOps" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            Disconnect-AzDevOps
            $connection = $script:connection
        }

        It " The connection should be null" {
            $connection | Should -BeNullOrEmpty
        }
    }

    Context " Get-AzDevOpsProject without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Get-AzDevOpsProject
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Get-AzDevOpsProject" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $projects = Get-AzDevOpsProject
        }

        It " The projects should not be null" {
            $projects | Should -Not -BeNullOrEmpty
        }

        It " The projects should be of type [PSCustomObject]" {
            $projects | Should -BeOfType [PSCustomObject]
        }

        It " The projects should have at least one project" {
            $projects.Count | Should -BeGreaterThan 0
        }

        It " The projects should have a project named $env:ADO_PROJECT" {
            $projects | Select -ExpandProperty name | Should -Contain $env:ADO_PROJECT
        }

        It " The projects should have a project named $env:ADO_PROJECT with an id" {
            $projects | Where-Object { $_.name -eq $env:ADO_PROJECT } | Select -ExpandProperty id | Should -Not -BeNullOrEmpty
        }

        It " The -Project Parameter should return a single result for $env:ADO_PROJECT" {
            $project = Get-AzDevOpsProject -Project $env:ADO_PROJECT
            $project | Should -Not -BeNullOrEmpty
        }

        It " The -Project Parameter should throw on a non-existing project" {
            { 
                Get-AzDevOpsProject -Project 'wrong'
            } | Should -Throw
        }

        It " The operation should fail with a wrong Organization" {
            { 
                Connect-AzDevOps -Organization 'wrong' -PAT $env:ADO_PAT
                Get-AzDevOpsProject -ErrorAction Stop
            } | Should -Throw 
        }

        It " The operation should fail with a wrong PAT" {
            { 
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT 'wrong'
                Get-AzDevOpsProject -ErrorAction Stop
            } | Should -Throw 
        }
    }

    Context " Export-AzDevOpsProject without a connection" {
        It " should throw an error" {
            { 
                Disconnect-AzDevOps
                Export-AzDevOpsProject -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR
            } | Should -Throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
        }
    }

    Context " Export-AzDevOpsProject" {
        BeforeAll {
            Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
            $project = Get-AzDevOpsProject -Project $env:ADO_PROJECT
            Export-AzDevOpsProject -Project $project.name -OutputPath $env:ADO_EXPORT_DIR
        }

        It " The output folder should contain a file named $env:ADO_PROJECT.prj.ado.json" {
            $file = Join-Path -Path $env:ADO_EXPORT_DIR -ChildPath "$env:ADO_PROJECT.prj.ado.json"
            Test-Path -Path $file | Should -Be $true
        }

        It " The output folder should contain a file named $env:ADO_PROJECT.prj.ado.json with a size greater than 0" {
            $file = Join-Path -Path $env:ADO_EXPORT_DIR -ChildPath "$env:ADO_PROJECT.prj.ado.json"
            (Get-Item $file).length | Should -BeGreaterThan 0
        }

        It " Should throw on a non-existing project" {
            { 
                Export-AzDevOpsProject -Project 'wrong' -OutputPath $env:ADO_EXPORT_DIR
            } | Should -Throw
        }

        It " The operation should fail with a wrong Organization" {
            { 
                Disconnect-AzDevOps
                Connect-AzDevOps -Organization 'wrong' -PAT $env:ADO_PAT
                Export-AzDevOpsProject -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR -ErrorAction Stop
            } | Should -Throw 
        }

        It " The operation should fail with a wrong PAT" {
            { 
                Disconnect-AzDevOps
                Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT 'wrong'
                Export-AzDevOpsProject -Project $env:ADO_PROJECT -OutputPath $env:ADO_EXPORT_DIR -ErrorAction Stop
            } | Should -Throw 
        }
    }
}

AfterAll {
}
