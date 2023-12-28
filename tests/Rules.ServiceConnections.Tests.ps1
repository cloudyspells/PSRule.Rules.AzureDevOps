BeforeAll {
    # Setup error handling
    $ErrorActionPreference = 'Stop';
    Set-StrictMode -Version latest;

    if ($Env:SYSTEM_DEBUG -eq 'true') {
        $VerbosePreference = 'Continue';
    }

    # Setup tests paths
    # $rootPath = $PWD;
    $rootPath = $env:GITHUB_WORKSPACE
    $ourModule = (Join-Path -Path $rootPath -ChildPath '/src/PSRule.Rules.AzureDevOps')

    Import-Module -Name $ourModule -Force
    $here = (Resolve-Path $PSScriptRoot).Path

    # Get tempory test output folder and store path
    $outPath = Get-Item -Path (Join-Path -Path $here -ChildPath 'out')
    $outPath = $outPath.FullName
    
    # Run rules with default token type
    $ruleResult = Invoke-PSRule -InputPath "$($outPath)/" -Module PSRule.Rules.AzureDevOps -Format Detect -Culture en

    # Get temporary test output folder for tests with the ReadOnly TokenType
    $outPathReadOnly = Get-Item -Path (Join-Path -Path $here -ChildPath 'outReadOnly')
    $outPathReadOnly = $outPathReadOnly.FullName

    # Run rules with ReadOnly token type
    $ruleResultReadOnly = Invoke-PSRule -InputPath "$($outPathReadOnly)/" -Module PSRule.Rules.AzureDevOps -Format Detect -Culture en

    # Get temporary test output folder for tests with the FineGrained TokenType
    $outPathFineGrained = Get-Item -Path (Join-Path -Path $here -ChildPath 'outFineGrained')
    $outPathFineGrained = $outPathFineGrained.FullName

    # Run rules with FineGrained token type
    $ruleResultFineGrained = Invoke-PSRule -InputPath "$($outPathFineGrained)/" -Module PSRule.Rules.AzureDevOps -Format Detect -Culture en
}

Describe "Azure.DevOps.ServiceConnections rules" {
    Context ' Azure.DevOps.ServiceConnections.Description' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -match 'fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 3;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -match 'fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 3;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -match 'fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 3;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Description' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.ServiceConnections.Description.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.ServiceConnections.Scope' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -match 'fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -match 'fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -match 'fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.Scope' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.ServiceConnections.Scope.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' -and $_.TargetName -match 'fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' -and $_.TargetName -match 'fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' -and $_.TargetName -match 'fail$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.WorkloadIdentityFederation' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.ServiceConnections.WorkloadIdentityFederation.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.ServiceConnections.ProductionBranchLimit' {
        It ' should pass for production targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' -and $_.TargetName -match 'fail$' })
            $ruleHits.Count | Should -Be 3;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' -and $_.TargetName -match 'fail$' })
            $ruleHits.Count | Should -Be 3;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ProductionBranchLimit' -and $_.TargetName -like '*success*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.ServiceConnections.ProductionBranchLimit.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.ServiceConnections.ClassicAzure' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ClassicAzure' -and $_.TargetName -like '*Classic*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for all other service connections' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ClassicAzure' -and $_.TargetName -notlike '*Classic*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 2;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ClassicAzure' -and $_.TargetName -like '*Classic*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ClassicAzure' -and $_.TargetName -notlike '*Classic*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 2;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ClassicAzure' -and $_.TargetName -like '*Classic*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.ClassicAzure' -and $_.TargetName -notlike '*Classic*' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 2;
        }

        It ' should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.ServiceConnections.ClassicAzure.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.ServiceConnections.GitHubPAT' {
        It ' should fail for connections named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.GitHubPAT' -and $_.TargetName -like '*GitHub*PAT*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.GitHubPAT' -and $_.TargetName -like '*GitHub*PAT*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.ServiceConnections.GitHubPAT' -and $_.TargetName -like '*GitHub*PAT*fail*' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an english markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.ServiceConnections.GitHubPAT.md');
            $fileExists | Should -Be $true;
        }
    }
}

AfterAll {
    # Remove Module
    Remove-Module -Name PSRule.Rules.AzureDevOps -Force;
}
