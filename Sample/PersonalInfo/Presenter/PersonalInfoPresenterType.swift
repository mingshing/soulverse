//
//  PersonalInfoPresenterType.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/19.
//

import Foundation

protocol PersonalInfoPresenterDelegate: AnyObject {
    
    func didUpdateViewModel(viewModel: PersonalInfoViewModel)
    func openChangePassword()
    func deleteAccount()
}


protocol PersonalInfoPresenterType: AnyObject {
    
    var viewModel: PersonalInfoViewModel? { get }
    var delegate: PersonalInfoPresenterDelegate? { get }
    var user: User { get }
    
    
    func numberOfSections() -> Int
    func numberOfItems(of section: Int) -> Int
    func titleForSection(_ section: Int) -> String
    func viewModelForIndex(indexPath: IndexPath) -> PersonalInfoCellViewModel?
    func didSelectForIndexPath(indexPath: IndexPath)
}
