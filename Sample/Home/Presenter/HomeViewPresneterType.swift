//
//  HomeViewPresneterType.swift
//  KonoSummit
//
//  Created by mingshing on 2021/8/15.
//

import Foundation

protocol HomeViewPresenterDelegate: AnyObject {
    func didUpdate(viewModel: HomeViewModel)
    func didUpdateSection(at index: IndexSet)
}

protocol HomeViewPresenterType {
    
    func fetchData(isUpdate: Bool)
    
    func numberOfSectionsOnTableView() -> Int
    
}
