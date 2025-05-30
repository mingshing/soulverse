//
//  ProfilePresenter.swift
//  KonoSummit
//
//  Created by mingshing on 2021/11/23.
//

import Foundation

class ProfilePresenter: ProfilePresenterType {
    
    var viewModel: ProfileViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            delegate?.didUpdateViewModel(viewModel: viewModel)
        }
    }
    var user: User
    weak var delegate: ProfilePresenterDelegate?
    
    init(
        user: User = User.instance,
        delegate: ProfilePresenterDelegate? = nil
    ) {
        self.user = user
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(userIdentityChanged), name: NSNotification.Name(rawValue: Notification.UserIdentityChange), object: nil)
        setupViewModel()
    }
    
    private func setupViewModel() {
        
        if user.isLoggedin && user.isVerified {
            viewModel = ProfileViewModel(sectionList: [.Membership, .About, .Other], status: .basic)
        } else if user.isLoggedin && !user.isVerified {
            viewModel = ProfileViewModel(sectionList: [.Membership, .About, .Other], status: .unverified)
        } else {
            viewModel = ProfileViewModel(sectionList: [.About], status: .anonymous)
        }
    }
    
    @objc private func userIdentityChanged() {
        
        if viewModel?.status == .anonymous && user.isLoggedin {
            delegate?.switchToHome()
        }
        setupViewModel()
    }
    
    func logout() {
        user.logout()
        setupViewModel()
    }
    
    func resendVerifyEmail() {
        
        guard let userId = self.user.userId else { return }
        
        UserService.sendVerifyEmail(userId: userId) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(_):
                weakSelf.delegate?.didSendVerifyEmail(error: nil)
            case .failure(let error):
                weakSelf.delegate?.didSendVerifyEmail(error: error)
            }
        }
    }
    
    
    func numberOfSections() -> Int {
        return viewModel?.sectionList.count ?? 0
    }
    
    func numberOfItems(of section: Int) -> Int {
        guard let viewModel = viewModel,
                viewModel.sectionList.count > section else {
            return 0
        }

        return viewModel.sectionList[section].rows.count
    }
        
    func titleForSection(_ section: Int) -> String {
        guard let viewModel = viewModel,
                viewModel.sectionList.count > section else {
            return ""
        }

        return viewModel.sectionList[section].sectionTitle
    }
    
    func viewModelForIndex(section: Int, row: Int) -> ProfileCellViewModel? {
        guard let viewModel = viewModel,
                viewModel.sectionList.count > section,
              viewModel.sectionList[section].rows.count > row  else {
            return nil
        }
        
        return viewModel.sectionList[section].rows[row].viewModel
    }
    
    func didSelectContentForIndex(section: Int, row: Int) {
        guard let viewModel = viewModel,
                viewModel.sectionList.count > section,
                viewModel.sectionList[section].rows.count > row else { return }
        
        let cellType = viewModel.sectionList[section].rows[row]
        delegate?.rowAction(contentType: cellType)
    }
}
