//
//  ProfilePresenterType.swift
//  KonoSummit
//
//  Created by mingshing on 2021/11/23.
//

import Foundation

protocol ProfilePresenterDelegate: AnyObject {
    
    func didUpdateViewModel(viewModel: ProfileViewModel)
    func didSendVerifyEmail(error: Error?)
    func rowAction(contentType: ProfileContentCategory)
    func switchToHome()
}


protocol ProfilePresenterType: AnyObject {
    
    var viewModel: ProfileViewModel? {get set}
    var delegate: ProfilePresenterDelegate? {get set}
    var user: User {get set}
    
    func logout()
    func resendVerifyEmail()
    
    func numberOfSections() -> Int
    func numberOfItems(of section: Int) -> Int
    func titleForSection(_ section: Int) -> String
    func viewModelForIndex(section: Int, row: Int) -> ProfileCellViewModel?
    func didSelectContentForIndex(section: Int, row: Int)
}
