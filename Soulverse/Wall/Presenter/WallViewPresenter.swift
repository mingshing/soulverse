//
//  WallViewPresenter.swift
//

import Foundation

protocol WallViewPresenterDelegate: AnyObject {
    func didUpdate(viewModel: WallViewModel)
    func didUpdateSection(at index: IndexSet)
}

protocol WallViewPresenterType: AnyObject {
    var delegate: WallViewPresenterDelegate? { get set }
    func fetchData(isUpdate: Bool)
    func numberOfSectionsOnTableView() -> Int
}

class WallViewPresenter: WallViewPresenterType {
    weak var delegate: WallViewPresenterDelegate?
    private var loadedModel: WallViewModel = WallViewModel(isLoading: false) {
        didSet {
            delegate?.didUpdate(viewModel: loadedModel)
        }
    }
    private var isFetchingData: Bool = false
    private var dataAccessQueue = DispatchQueue(label: "wall_data", attributes: .concurrent)
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