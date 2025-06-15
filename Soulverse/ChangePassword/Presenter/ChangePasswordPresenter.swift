//
//  ChangePasswordPresenter.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/21.
//

import Foundation
import Toaster

class ChangePasswordPresenter: ChangePasswordPresenterType {
    
    var viewModel: ChangePasswordViewModel?
    private var user: User
    private var oldPasswordStr: String = ""
    private var newPasswordStr: String = ""
    private var confirmPasswordStr: String = ""
    private var oldPasswordErrorMsg: String?
    private var newPasswordErrorMsg: String?
    weak var delegate: ChangePasswordPresenterDelegate?
    
    init(
        _ user: User = User.instance,
        delegate: ChangePasswordPresenterDelegate? = nil
    ) {
        
        self.user = user
        self.delegate = delegate
        setupViewModel()
    }
    
    private func setupViewModel() {
        
        viewModel = ChangePasswordViewModel(sectionList:  [ChangePasswordCategory(.oldPassword), ChangePasswordCategory(.newPassword)])
        
    }
    
    
    private func checkInputValid() -> Bool {
        
        return !oldPasswordStr.isEmpty && !newPasswordStr.isEmpty && !confirmPasswordStr.isEmpty
    }
    
    func changePassword() {
        
        if confirmPasswordStr != newPasswordStr {
            newPasswordErrorMsg = NSLocalizedString("change_password_new_password_inconsistent", comment: "")
            delegate?.didUpdateViewModel(viewModel: viewModel!)
        } else {
            newPasswordErrorMsg = nil
            oldPasswordErrorMsg = nil
            delegate?.didUpdateViewModel(viewModel: viewModel!)
            guard let userId = user.userId else { return }
            
            UserService.changePassword(userId: userId, oldPassword: oldPasswordStr, newPassword: newPasswordStr) { [weak self] result in
                guard let weakSelf = self else { return }
                switch result {
                case .success(_):
                    weakSelf.delegate?.didChangePassword()
                case .failure(let error):
                    switch error {
                    case .FailedAction(_):
                        weakSelf.oldPasswordErrorMsg = NSLocalizedString("change_password_old_password_error", comment: "")
                        weakSelf.delegate?.didUpdateViewModel(viewModel: weakSelf.viewModel!)
                    case .ServerError(_):
                        Toast(text: error.description, duration: Delay.short).show()
                    default:
                        print("change user password encounter server error")
                    }
                }
            }
        }
        
    }
    
    func inputTextChangedWithCell(_ viewModel: ChangePasswordCellViewModel) {
        switch viewModel.type {
        case .newPassword:
            newPasswordStr = viewModel.text ?? ""
        case .oldPassword:
            oldPasswordStr = viewModel.text ?? ""
        case .confirmPassword:
            confirmPasswordStr = viewModel.text ?? ""
        }
        
        delegate?.updateActionStatus(isEnable: checkInputValid())
    }
    
    func numberOfSections() -> Int {
        return viewModel?.sectionList.count ?? 0
    }
    
    func numberOfItems(of section: Int) -> Int {
        guard let viewModel = viewModel,
                viewModel.sectionList.count > section else {
            return 0
        }

        return viewModel.sectionList[section].viewModels.count
    }
    
    func titleForSection(_ section: Int) -> String {
        guard let viewModel = viewModel,
                viewModel.sectionList.count > section else {
            return ""
        }

        return viewModel.sectionList[section].sectionTitle
    }
    func errorMsgForSection(_ section: Int) -> String? {
        
        switch section {
        case ChangePasswordCategoryType.oldPassword.rawValue:
            return oldPasswordErrorMsg
        case ChangePasswordCategoryType.newPassword.rawValue:
            return newPasswordErrorMsg
        default:
            return nil
        }
    }
    
    
    func viewModelForIndex(indexPath: IndexPath) -> ChangePasswordCellViewModel? {
        guard let viewModel = viewModel,
              viewModel.sectionList.count > indexPath.section,
              viewModel.sectionList[indexPath.section].viewModels.count > indexPath.row  else {
            return nil
        }
        
        return viewModel.sectionList[indexPath.section].viewModels[indexPath.row]
    }
    
}
