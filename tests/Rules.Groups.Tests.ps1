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

Describe 'Azure.DevOps.Groups rules' {
    Context 'Azure.DevOps.Groups.ProjectAdmins.MinMembers' {
        It ' should pass once' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Groups.ProjectAdmins.MinMembers' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass once for ReadOnly token type' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Groups.ProjectAdmins.MinMembers' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass once for FineGrained token type' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Groups.ProjectAdmins.MinMembers' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Groups.ProjectAdmins.MaxMembers' {
        It ' should pass once' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Groups.ProjectAdmins.MaxMembers' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass once for ReadOnly token type' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Groups.ProjectAdmins.MaxMembers' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass once for FineGrained token type' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Groups.ProjectAdmins.MaxMembers' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }
    }

    Context 'Azure.DevOps.Groups.ProjectValidUsers.DoNotAssignMemberOfOtherGroups' {
        It ' should pass once' {
            $ruleHits = @($ruleResult | Where-Object { $_.RuleName -eq 'Azure.DevOps.Groups.ProjectValidUsers.DoNotAssignMemberOfOtherGroups' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass once for ReadOnly token type' {
            $ruleHits = @($ruleResultReadOnly | Where-Object { $_.RuleName -eq 'Azure.DevOps.Groups.ProjectValidUsers.DoNotAssignMemberOfOtherGroups' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }

        It ' should pass once for FineGrained token type' {
            $ruleHits = @($ruleResultFineGrained | Where-Object { $_.RuleName -eq 'Azure.DevOps.Groups.ProjectValidUsers.DoNotAssignMemberOfOtherGroups' })
            $ruleHits[0].Outcome | Should -Be 'Pass';
            $ruleHits.Count | Should -Be 1;
        }
    }
}

AfterAll {
    # Remove Module
    Remove-Module -Name PSRule.Rules.AzureDevOps -Force;
}
