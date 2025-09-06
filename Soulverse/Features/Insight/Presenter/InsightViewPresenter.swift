//
//  InsightViewPresenter.swift
//

import Foundation

protocol InsightViewPresenterDelegate: AnyObject {
    func didUpdate(viewModel: InsightViewModel)
    func didUpdateSection(at index: IndexSet)
}

protocol InsightViewPresenterType: AnyObject {
    var delegate: InsightViewPresenterDelegate? { get set }
    func fetchData(isUpdate: Bool)
    func numberOfSectionsOnTableView() -> Int
}

class InsightViewPresenter: InsightViewPresenterType {
    weak var delegate: InsightViewPresenterDelegate?
    private var loadedModel: InsightViewModel = InsightViewModel(isLoading: false) {
        didSet {
            delegate?.didUpdate(viewModel: loadedModel)
        }
    }
    private var isFetchingData: Bool = false
    private var dataAccessQueue = DispatchQueue(label: "insight_data", attributes: .concurrent)
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
