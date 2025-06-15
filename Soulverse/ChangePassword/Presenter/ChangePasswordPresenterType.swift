//
//  ChangePasswordPresenterType.swift
//
//  Created by mingshing on 2022/2/21.
//

import Foundation

protocol ChangePasswordPresenterDelegate: AnyObject {
    
    func didUpdateViewModel(viewModel: ChangePasswordViewModel)
    func updateActionStatus(isEnable: Bool)
    func didChangePassword()
}


protocol ChangePasswordPresenterType: AnyObject {
    
    var viewModel: ChangePasswordViewModel? {get}
    var delegate: ChangePasswordPresenterDelegate? {get}
    
    func changePassword()
    
    func inputTextChangedWithCell(_ viewModel: ChangePasswordCellViewModel)
    func numberOfSections() -> Int
    func numberOfItems(of section: Int) -> Int
    func titleForSection(_ section: Int) -> String
    func errorMsgForSection(_ section: Int) -> String?
    func viewModelForIndex(indexPath: IndexPath) -> ChangePasswordCellViewModel?
}
