//
//  ChangePasswordCellViewModel.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/21.
//

import Foundation

enum ChangePasswordCellType {
    case oldPassword
    case newPassword
    case confirmPassword
    
    var rowIdx: Int {
        switch self {
        case .oldPassword, .newPassword:
            return 0
        case .confirmPassword:
            return 1
        }
    }
}

class ChangePasswordCellViewModel {
    
    let type: ChangePasswordCellType
    var text: String? = nil
    var isSecureEnable: Bool = true
    
    init(type: ChangePasswordCellType) {
        self.type = type
    }
    
    var placeholder: String {
        switch type {
        case .oldPassword:
            return NSLocalizedString("change_password_old_password_placeholder", comment: "")
        case .newPassword:
            return NSLocalizedString("change_password_new_password_placeholder", comment: "")
        case .confirmPassword:
            return NSLocalizedString("change_password_confirm_password_placeholder", comment: "")
        }
    }
    var needSeparator: Bool {
        switch type {
        case .newPassword:
            return true
        default:
            return false
        }
    }
    
}
