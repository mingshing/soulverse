//
//  InnerCosmoViewPresenterType.swift
//

import Foundation

protocol InnerCosmoViewPresenterDelegate: AnyObject {
    func didUpdate(viewModel: HomeViewModel)
    func didUpdateSection(at index: IndexSet)
}

protocol InnerCosmoViewPresenterType {
    
    func fetchData(isUpdate: Bool)
    
    func numberOfSectionsOnTableView() -> Int
    
}
