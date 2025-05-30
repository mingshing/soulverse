//
//  ChangePasswordViewModel.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/21.
//

import Foundation

struct ChangePasswordViewModel {
    
    var sectionList: [ChangePasswordCategory]
    
}

enum ChangePasswordCategoryType: Int {
    case oldPassword
    case newPassword
}


struct ChangePasswordCategory {
    
    var viewModels: [ChangePasswordCellViewModel]
    var sectionTitle: String
    
    init(_ type: ChangePasswordCategoryType) {
        switch type {
        case .oldPassword:
            sectionTitle = NSLocalizedString("change_password_old_password", comment: "")
            viewModels = [ChangePasswordCellViewModel(type: .oldPassword)]
        case .newPassword:
            sectionTitle = NSLocalizedString("change_password_new_password", comment: "")
            viewModels = [
                ChangePasswordCellViewModel(type: .newPassword),
                ChangePasswordCellViewModel(type: .confirmPassword)]
        }
    }
}
