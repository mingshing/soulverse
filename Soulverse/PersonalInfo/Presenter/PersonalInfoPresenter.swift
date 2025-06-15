//
//  PersonalInfoPresenter.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/19.
//

import Foundation

class PersonalInfoPresenter: PersonalInfoPresenterType {

    var viewModel: PersonalInfoViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            delegate?.didUpdateViewModel(viewModel: viewModel)
        }
    }
    weak var delegate: PersonalInfoPresenterDelegate?
    var user: User
    
    init(
        user: User = User.instance,
        delegate: PersonalInfoPresenterDelegate?
    ) {
        self.user = user
        self.delegate = delegate
        setupViewModel()
    }
    
    func setupViewModel() {
        viewModel = PersonalInfoViewModel(sectionList: [.Account(user: user), .Nickname(user: user), .Others], avatarImageURL: user.avatarImageURL)
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
    
    func viewModelForIndex(indexPath: IndexPath) -> PersonalInfoCellViewModel? {
        guard let viewModel = viewModel,
              viewModel.sectionList.count > indexPath.section,
              viewModel.sectionList[indexPath.section].rows.count > indexPath.row  else {
            return nil
        }
        
        return viewModel.sectionList[indexPath.section].rows[indexPath.row].viewModel
    }
    
    func didSelectForIndexPath(indexPath: IndexPath) {
        guard let viewModel = viewModel,
              viewModel.sectionList.count > indexPath.section,
              viewModel.sectionList[indexPath.section].rows.count > indexPath.row  else {
            return
        }
        let selectedRow = viewModel.sectionList[indexPath.section].rows[indexPath.row]
        
        if selectedRow == .ChangePassword {
            delegate?.openChangePassword()
        } else if selectedRow == .DeleteAccount {
            delegate?.deleteAccount()
        }
    }
}
