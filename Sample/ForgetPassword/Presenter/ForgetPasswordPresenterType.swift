//
//  ForgetPasswordPresenterType.swift
//  KonoSummit
//
//  Created by mingshing on 2021/12/13.
//

import Foundation

enum ForgetPasswordInputCheckResult {
    case Valid
    case EmailEmpty
    case InvalidEmail
}

protocol ForgetPasswordPresenterDelegate: AnyObject {
    
    func didUpdateViewModel(viewModel: ForgetPasswordViewModel)
    func didFinishWithError(_ error: UserServiceError)
    func didSendRecoverEmail()
    func dismissView()
}


protocol ForgetPasswordPresenterType: AnyObject {
    
    var delegate: ForgetPasswordPresenterDelegate? {get set}
    func checkInputValid(account: String?) -> ForgetPasswordInputCheckResult
    func didTapSendButton(email: String)
    func didTapBackButton()
}
