//
//  PersonalInfoViewModel.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/19.
//
import Foundation

struct PersonalInfoViewModel {
    
    var sectionList: [PersonalInfoSectionCategory]
    var avatarImageURL: String?
}


enum PersonalInfoSectionCategory {
    
    case Account(user: User)
    case Nickname(user: User)
    case Others
    
    var rows: [PersonalInfoCategory] {
        switch self {
        case .Account(let user):
            let registerChannel = user.registerChannel ?? "kono"
            if registerChannel == "kono" {
                return [.Account(user: user), .ChangePassword]
            }
            return [.Account(user: user)]
        case .Nickname(let user):
            return [.Nickname(user: user)]
        case .Others:
            return [.DeleteAccount]
        }
    }
    
    var sectionTitle: String {
        switch self {
        case .Account:
            return NSLocalizedString("personal_info_section_account", comment: "")
        case .Nickname:
            return NSLocalizedString("personal_info_section_nickname", comment: "")
        case .Others:
            return NSLocalizedString("personal_info_section_others", comment: "")
        }
    }
}

enum PersonalInfoCategory: Equatable {
    static func == (lhs: PersonalInfoCategory, rhs: PersonalInfoCategory) -> Bool {
        switch (lhs, rhs){
        case (.Id, .Id), (.Account, .Account), (.ChangePassword, .ChangePassword), (.Nickname, .Nickname), (.DeleteAccount, .DeleteAccount):
            return true
        default:
            return false
        }
    }
    
    
    case Id(user: User)
    case Account(user: User)
    case ChangePassword
    case Nickname(user: User)
    case DeleteAccount
    
    var viewModel: PersonalInfoCellViewModel {
        switch self {
        case .Id(let user):
            return PersonalInfoCellViewModel(title: user.userId ?? "", isNeedSeparator: false, isHighlight: false, iconName: "iconCopy")
        case .Account(let user):
            return PersonalInfoCellViewModel(title: user.email ?? "", isNeedSeparator: true, isHighlight: false, registerChannel: user.registerChannel)
        case .ChangePassword:
            return PersonalInfoCellViewModel(title: NSLocalizedString("personal_info_row_change_password", comment: ""), isNeedSeparator: false, isHighlight: true, iconName: "iconRightArrow28")
        case .Nickname(let user):
            return PersonalInfoCellViewModel(title: user.nickName ?? "", isNeedSeparator: false, isHighlight: false)
        case .DeleteAccount:
            return PersonalInfoCellViewModel(title: NSLocalizedString("personal_info_row_delete_account", comment: ""), isNeedSeparator: false, isHighlight: false, textColor: .errorRed)
        }
    }
    
}
