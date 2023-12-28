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
    $noExtraLicenseBaselineResult = Invoke-PSRule -InputPath "$($outPath)/" -Module PSRule.Rules.AzureDevOps -Format Detect -Culture en -Baseline Baseline.NoExtraLicense

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

Describe "Azure.DevOps.Repos rules" {
    Context ' Azure.DevOps.Repos.HasDefaultBranchPolicy' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasDefaultBranchPolicy' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasDefaultBranchPolicy' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasDefaultBranchPolicy' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasDefaultBranchPolicy' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasDefaultBranchPolicy' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.HasDefaultBranchPolicy' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.HasDefaultBranchPolicy.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.DefaultBranchPolicyIsEnabled' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyIsEnabled' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyIsEnabled' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyIsEnabled' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyIsEnabled' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyIsEnabled' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyIsEnabled' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.DefaultBranchPolicyIsEnabled.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.DefaultBranchPolicyMinimumReviewers' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyMinimumReviewers' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyMinimumReviewers' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyMinimumReviewers' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyMinimumReviewers' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyMinimumReviewers' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyMinimumReviewers' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.DefaultBranchPolicyMinimumReviewers.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.DefaultBranchPolicyAllowSelfApproval' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyAllowSelfApproval' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyAllowSelfApproval' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyAllowSelfApproval' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyAllowSelfApproval' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyAllowSelfApproval' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyAllowSelfApproval' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.DefaultBranchPolicyAllowSelfApproval.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.DefaultBranchPolicyResetVotes' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyResetVotes' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyResetVotes' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyResetVotes' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyResetVotes' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyResetVotes' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyResetVotes' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.DefaultBranchPolicyResetVotes.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.Readme' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.Readme' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.Readme.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.License' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.License' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.License.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.DefaultBranchPolicyEnforceLinkedWorkItems' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyEnforceLinkedWorkItems' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.DefaultBranchPolicyEnforceLinkedWorkItems.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.DefaultBranchPolicyCommentResolution' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyCommentResolution' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyCommentResolution' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyCommentResolution' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyCommentResolution' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyCommentResolution' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyCommentResolution' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.DefaultBranchPolicyCommentResolution.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.DefaultBranchPolicyMergeStrategy' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyMergeStrategy' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyMergeStrategy' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyMergeStrategy' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyMergeStrategy' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyMergeStrategy' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyMergeStrategy' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.DefaultBranchPolicyMergeStrategy.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass none' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should not be run in the Baseline.NoExtraLicense baseline' {
            $ruleHits = @($noExtraLicenseBaselineResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' })
            $ruleHits.Count | Should -Be 0;
        }

        It ' should not be present with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' })
            $ruleHits.Count | Should -Be 0;
        }

        It ' should not be present with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' })
            $ruleHits.Count | Should -Be 0;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass none' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should not be run in the Baseline.NoExtraLicense baseline' {
            $ruleHits = @($noExtraLicenseBaselineResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' })
            $ruleHits.Count | Should -Be 0;
        }

        It ' should not be present with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' })
            $ruleHits.Count | Should -Be 0;
        }

        It ' should not be present with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' })
            $ruleHits.Count | Should -Be 0;
        }

        It ' should have an English markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.InheritedPermissions' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.InheritedPermissions' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.InheritedPermissions' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should not be present with the ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.InheritedPermissions' })
            $ruleHits.Count | Should -Be 0;
        }

        It ' should be the same as default with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.InheritedPermissions' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.InheritedPermissions' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.InheritedPermissions.md');
            $fileExists | Should -Be $true;
        }
    }

    Context ' Azure.DevOps.Repos.DefaultBranchPolicyRequireBuild' {
        It ' should fail for targets named fail' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyRequireBuild' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass for targets named success' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyRequireBuild' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a ReadOnly TokenType' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyRequireBuild' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyRequireBuild' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should be the same with a FineGrained TokenType' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyRequireBuild' -and $_.TargetName -match 'fail-project$' })
            $ruleHits[0].Outcome | Should -Be 'Fail';
            $ruleHits.Count | Should -Be 1;

            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Repos.DefaultBranchPolicyRequireBuild' -and $_.TargetName -match 'success' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should have a markdown help file' {
            $fileExists = Test-Path -Path (Join-Path -Path $ourModule -ChildPath 'en/Azure.DevOps.Repos.DefaultBranchPolicyRequireBuild.md');
            $fileExists | Should -Be $true;
        }
    }
}

AfterAll {
    Remove-Module -Name PSRule.Rules.AzureDevOps -Force
}