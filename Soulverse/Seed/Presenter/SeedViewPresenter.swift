//
//  SeedViewPresenter.swift
//

import Foundation

protocol SeedViewPresenterDelegate: AnyObject {
    func didUpdate(viewModel: SeedViewModel)
    func didUpdateSection(at index: IndexSet)
}

protocol SeedViewPresenterType: AnyObject {
    var delegate: SeedViewPresenterDelegate? { get set }
    func fetchData(isUpdate: Bool)
    func numberOfSectionsOnTableView() -> Int
}

class SeedViewPresenter: SeedViewPresenterType {
    weak var delegate: SeedViewPresenterDelegate?
    private var loadedModel: SeedViewModel = SeedViewModel(isLoading: false) {
        didSet {
            delegate?.didUpdate(viewModel: loadedModel)
        }
    }
    private var isFetchingData: Bool = false
    private var dataAccessQueue = DispatchQueue(label: "seed_data", attributes: .concurrent)
    init() {}
    public func fetchData(isUpdate: Bool = false) {
        if isFetchingData { return }
        if !isUpdate { loadedModel.isLoading = true }
        isFetchingData = true
    }
    public func numberOfSectionsOnTableView() -> Int {
        return 0
    }
} 