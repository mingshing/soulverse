//
//  SoulQuestViewPresenter.swift
//

import Foundation

protocol SoulQuestViewPresenterDelegate: AnyObject {
    func didUpdate(viewModel: SoulQuestViewModel)
    func didUpdateSection(at index: IndexSet)
}

protocol SoulQuestViewPresenterType: AnyObject {
    var delegate: SoulQuestViewPresenterDelegate? { get set }
    func fetchData(isUpdate: Bool)
    func numberOfSectionsOnTableView() -> Int
}

class SoulQuestViewPresenter: SoulQuestViewPresenterType {
    weak var delegate: SoulQuestViewPresenterDelegate?
    private var loadedModel: SoulQuestViewModel = SoulQuestViewModel(isLoading: false) {
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