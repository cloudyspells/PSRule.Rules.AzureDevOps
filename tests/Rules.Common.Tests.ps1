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

    Import-Module -Name $ourModule -Force;
    $here = (Resolve-Path $PSScriptRoot).Path;

     # Create tempory test output folder and store path
    $outPath = New-Item -Path (Join-Path -Path $here -ChildPath 'out') -ItemType Directory -Force;
    $outPath = $outPath.FullName;

    # Export all Azure DevOps rule data for project 'psrule-fail-project' to output folder
    Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT
    Export-AzDevOpsRuleData -Project $env:ADO_PROJECT -OutputPath $outPath

    # Create a temporary test output folder for tests with the ReadOnly TokenType
    $outPathReadOnly = New-Item -Path (Join-Path -Path $here -ChildPath 'outReadOnly') -ItemType Directory -Force;
    $outPathReadOnly = $outPathReadOnly.FullName;

    # Export all Azure DevOps rule data for project 'psrule-fail-project' to ReadOnly output folder
    Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_READONLY -TokenType ReadOnly
    Export-AzDevOpsRuleData -Project $env:ADO_PROJECT -OutputPath $outPathReadOnly

    # Create a temporary test output folder for tests with the FineGrained TokenType
    $outPathFineGrained = New-Item -Path (Join-Path -Path $here -ChildPath 'outFineGrained') -ItemType Directory -Force;
    $outPathFineGrained = $outPathFineGrained.FullName;

    # Export all Azure DevOps rule data for project 'psrule-fail-project' to FineGrained output folder
    Connect-AzDevOps -Organization $env:ADO_ORGANIZATION -PAT $env:ADO_PAT_FINEGRAINED -TokenType FineGrained
    Export-AzDevOpsRuleData -Project $env:ADO_PROJECT -OutputPath $outPathFineGrained
}

Describe "PSRule.Rules.AzureDevOps Rules" {
    Context ' Base rules' {
        It ' should contain 59 rules' {
            $rules = Get-PSRule -Module PSRule.Rules.AzureDevOps
            $rules.Count | Should -Be 59
        }

        It ' should contain a markdown help file for each rule' {
            $rules = Get-PSRule -Module PSRule.Rules.AzureDevOps
            $rules | ForEach-Object {
                $helpFile = Join-Path -Path "$ourModule/en" -ChildPath "$($_.Name).md"
                Test-Path -Path $helpFile | Should -Be $true
            }
        }
    }
}

AfterAll {
    # Remove Module
    Disconnect-AzDevOps
    Remove-Module -Name PSRule.Rules.AzureDevOps -Force;
}