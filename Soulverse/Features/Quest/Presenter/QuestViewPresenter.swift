//
//  QuestViewPresenter.swift
//

import Foundation

protocol QuestViewPresenterDelegate: AnyObject {
    func didUpdate(viewModel: QuestViewModel)
    func didUpdateSection(at index: IndexSet)
}

protocol QuestViewPresenterType: AnyObject {
    var delegate: QuestViewPresenterDelegate? { get set }
    func fetchData(isUpdate: Bool)
    func numberOfSectionsOnTableView() -> Int
}

class QuestViewPresenter: QuestViewPresenterType {
    weak var delegate: QuestViewPresenterDelegate?
    private var loadedModel: QuestViewModel = QuestViewModel(isLoading: false) {
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