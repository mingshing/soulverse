//
//  ProfileViewModel.swift
//  KonoSummit
//
//  Created by mingshing on 2021/11/23.
//

import Foundation

enum ProfileStatus {
    case anonymous
    case unverified
    case basic
}


struct ProfileViewModel {
    
    var sectionList: [ProfileSectionCategory]
    var status: ProfileStatus

}


enum ProfileContentCategory {
    
    case PersonalInfo
    case Policy
    case Privacy
    case FAQ
    case Contact
    case Logout
    
    
    var viewModel: ProfileCellViewModel {
        switch self {
        case .PersonalInfo:
            return ProfileCellViewModel(title: NSLocalizedString("profile_info", comment: ""), isNeedSeparator: true, iconName: "iconPersonalInfo", actionIcon: "iconRightArrow28")
        case .Policy:
            return ProfileCellViewModel(title: NSLocalizedString("profile_policy", comment: ""), isNeedSeparator: true)
        case .Privacy:
            return ProfileCellViewModel(title: NSLocalizedString("profile_privacy", comment: ""), isNeedSeparator: true)
        case .FAQ:
            return ProfileCellViewModel(title: NSLocalizedString("profile_faq", comment: ""), isNeedSeparator: true)
        case .Contact:
            return ProfileCellViewModel(title: NSLocalizedString("profile_contactus", comment: ""), isNeedSeparator: false, actionIcon: "iconOutsideLink")
        case .Logout:
            return ProfileCellViewModel(title: NSLocalizedString("logout", comment: ""), isNeedSeparator: false)
        }
    }
    
}

enum ProfileSectionCategory {
    
    case Membership
    case About
    case Other
    
    var rows: [ProfileContentCategory] {
        switch self {
        case .Membership:
            return [.PersonalInfo]
        case .About:
            return [.Policy, .Privacy, .FAQ, .Contact]
        case .Other:
            return [.Logout]
        }
    }
    
    var sectionTitle: String {
        switch self {
        case .Membership:
            return NSLocalizedString("profile_membership", comment: "")
        case .About:
            return NSLocalizedString("profile_about", comment: "")
        case .Other:
            return NSLocalizedString("profile_others", comment: "")
        }
    }
}
