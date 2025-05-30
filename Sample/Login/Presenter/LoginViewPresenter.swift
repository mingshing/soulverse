//
//  LoginViewPresenter.swift
//  KonoSummit
//
//  Created by mingshing on 2021/12/6.
//

import Foundation


class LoginViewPresenter: LoginViewPresenterType {
    
    weak var delegate: LoginViewPresenterDelegate?
    private var sourcePage: AppLocation
    private var tracker: CoreTracker?
    private var authService: AuthService?
    var viewModel: LoginViewModel 
    
    init(
        _ defaultMode: LoginViewDisplayMode = .Register,
        sourcePage: AppLocation,
        delegate: LoginViewPresenterDelegate? = nil,
        tracker: CoreTracker? = SummitTracker.shared
    ) {
        self.delegate = delegate
        self.tracker = tracker
        self.sourcePage = sourcePage
        viewModel = LoginViewModel(sectionList: [.ThirdParty, .Email], displayMode: defaultMode)
    }
    
    func numberOfSections() -> Int {
        viewModel.sectionList.count
    }
    
    func numberOfItems(of section: Int) -> Int {
        guard section < viewModel.sectionList.count else { return 0 }
        return viewModel.sectionList[section].platforms.count
    }
    
    func loginPlatformForIndex(section: Int, row: Int) -> LoginPlatform? {
        guard section < viewModel.sectionList.count,
              row < viewModel.sectionList[section].platforms.count
        else { return nil }
        
        return viewModel.sectionList[section].platforms[row]
    }
    
    func didTapLoginAction(platform: LoginPlatform) {
        
        authService = platform.authService
        guard let authService = authService else { return }
        
        delegate?.startAuthProcess()
        
        if viewModel.displayMode == .Register {
            
            authService.signup { [weak self] res in
                guard let weakSelf = self else { return }
                weakSelf.delegate?.didFinishedAuthProcess(res)
                weakSelf.trackAuthResult(res, platform: platform)
            }
            tracker?.track(AccountEvent.clickRegister(platform: platform))
            
        } else if viewModel.displayMode == .Login {
            authService.login { [weak self] res in
                guard let weakSelf = self else { return }
                weakSelf.delegate?.didFinishedAuthProcess(res)
                weakSelf.trackAuthResult(res, platform: platform)
            }
            tracker?.track(AccountEvent.clickLogin(platform: platform))
        }
    }
    
    func didTapBackButton() {
        delegate?.dismissView()
        tracker?.track(AccountEvent.clickBack)
    }
    
    private func trackAuthResult(_ result: AuthResult, platform: LoginPlatform) {
        
        switch result {
        case .AuthLoginSuccess:
            tracker?.track(AccountEvent.logIn(platform: platform))
        case .AuthSignupSuccess:
            tracker?.updateUserAcquireInfo()
            tracker?.track(AccountEvent.signUp(platform: platform))
        case .ThirdPartyServiceError(let errorMsg):
            var reason = result.description
            if let error = errorMsg {
                reason.append(": \(error)")
            }
            tracker?.track(AccountEvent.error(reason: reason, platform: platform))
        default:
            tracker?.track(AccountEvent.error(reason: result.description, platform: platform))
        }
    }
    
    func didTapSkipButton() {
        delegate?.dismissView()
        tracker?.track(AccountEvent.clickSkip)
    }
    
    func didTapSwitchButton() {
        let oldDisplayMode = viewModel.displayMode
        let newDisplayMode: LoginViewDisplayMode = (viewModel.displayMode == .Login) ? .Register : .Login
        viewModel.displayMode = newDisplayMode
        
        delegate?.didChangeDisplayMode(viewModel)
        tracker?.track(AccountEvent.clickSwitch(from: oldDisplayMode, to: newDisplayMode))
    }
    
    func didTapUserPolicy() {
        delegate?.openPolicy()
        
        tracker?.track(AccountEvent.clickPolicy)
    }
    
    func didTapForgetPassword() {
        delegate?.openForgetPassword()
        
        tracker?.track(AccountEvent.clickForgetPassword)
    }
}
