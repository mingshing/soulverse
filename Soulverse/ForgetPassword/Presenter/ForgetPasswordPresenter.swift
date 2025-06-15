//
//  ForgetPasswordPresenter.swift
//  KonoSummit
//
//  Created by mingshing on 2021/12/13.
//

import Foundation


class ForgetPasswordPresenter: ForgetPasswordPresenterType {
    
    weak var delegate: ForgetPasswordPresenterDelegate?
    private var viewModel: ForgetPasswordViewModel {
        didSet {
            delegate?.didUpdateViewModel(viewModel: viewModel)
        }
    }

    init(delegate: ForgetPasswordPresenterDelegate? = nil) {
        self.delegate = delegate
        self.viewModel = ForgetPasswordViewModel(isLoading: false)
    }
    
    
    func checkInputValid(account: String?) -> ForgetPasswordInputCheckResult {
        
        guard let account = account else {
            return .EmailEmpty
        }
        if account.isEmpty {
            return .EmailEmpty
        } else if !account.isValidEmail {
            return .InvalidEmail
        }
        
        return .Valid
    }
    
    func didTapSendButton(email: String) {
        viewModel.isLoading = true
        
        UserService.remindPassword(account: email) { [weak self] result in
            guard let weakSelf = self else { return }
            weakSelf.viewModel.isLoading = false
            switch result {
            case .success(_):
                weakSelf.delegate?.didSendRecoverEmail()
            case .failure(let error):
                weakSelf.delegate?.didFinishWithError(error)
            }
        }
    }
    
    func didTapBackButton() {
        delegate?.dismissView()
    }
}
