//
//  ToolsViewPresenter.swift
//

import Foundation

protocol ToolsViewPresenterDelegate: AnyObject {
    func didUpdate(viewModel: ToolsViewModel)
    func didUpdateSection(at index: IndexSet)
}

protocol ToolsViewPresenterType: AnyObject {
    var delegate: ToolsViewPresenterDelegate? { get set }
    func fetchData(isUpdate: Bool)
    func numberOfSectionsOnTableView() -> Int
}

class ToolsViewPresenter: ToolsViewPresenterType {
    weak var delegate: ToolsViewPresenterDelegate?
    private var loadedModel: ToolsViewModel = ToolsViewModel(isLoading: false) {
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