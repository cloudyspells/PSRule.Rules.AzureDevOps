# PSRule rule definitions for Azure DevOps Groups

# Synopsis: The Project Administrators group should not have less than 2 members
Rule 'Azure.DevOps.Groups.ProjectAdmins.MinMembers' `
    -Ref 'ADO-GRP-001' `
    -Type 'Azure.DevOps.Group' `
    -If { $TargetObject.displayName -eq 'Project Administrators' } `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description "The Project Administrators group should not have less than 2 members"
        Reason "The Project Administrators group has less than 2 members"
        Recommend "Consider adding more members to the Project Administrators group"
        # Links "https://docs.microsoft.com/en-us/azure/devops/organizations/security/permissions?view=azure-devops#project-administrator"
        AllOf {
            $Assert.HasField($TargetObject, "Members", $true)
            $Assert.HasField($TargetObject, "Members.Length", $true)
            $Assert.GreaterOrEqual($TargetObject, "Members.Length", 2)
        }
}

# Synopsis: The Project Administrators group should not have more than 4 members
Rule 'Azure.DevOps.Groups.ProjectAdmins.MaxMembers' `
    -Ref 'ADO-GRP-002' `
    -Type 'Azure.DevOps.Group' `
    -If { $TargetObject.displayName -eq 'Project Administrators' } `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description "The Project Administrators group should not have more than 4 members"
        Reason "The Project Administrators group has more than 4 members"
        Recommend "Consider removing members from the Project Administrators group"
        # Links "https://docs.microsoft.com/en-us/azure/devops/organizations/security/permissions?view=azure-devops#project-administrator"
        AllOf {
            $Assert.HasField($TargetObject, "Members", $true)
            $Assert.HasField($TargetObject, "Members.Length", $true)
            $Assert.LessOrEqual($TargetObject, "Members.Length", 4)
        }
}

# Synopsis: The Project Valid User should only be member of the Project Collection Valid Users group
Rule 'Azure.DevOps.Groups.ProjectValidUsers.DoNotAssignMemberOfOtherGroups' `
    -Ref 'ADO-GRP-003' `
    -Type 'Azure.DevOps.Group' `
    -If { $TargetObject.displayName -eq 'Project Valid Users' } `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description "The Project Valid Users group should only be member of the Project Collection Valid Users group"
        Reason "The Project Valid User is member of other groups than the Project Collection Valid Users group"
        Recommend "Consider removing the Project Valid User from other groups than the Project Collection Valid Users group"
        # Links "https://docs.microsoft.com/en-us/azure/devops/organizations/security/permissions?view=azure-devops#project-valid-user"
        AllOf {
            $Assert.HasField($TargetObject, "MemberOf", $true)
            $Assert.HasField($TargetObject, "MemberOf.Length", $true)
            $Assert.LessOrEqual($TargetObject, "MemberOf.Length", 1)
            $Assert.HasFieldValue($TargetObject, "MemberOf[0].displayName", "Project Collection Valid Users")
        }
}
