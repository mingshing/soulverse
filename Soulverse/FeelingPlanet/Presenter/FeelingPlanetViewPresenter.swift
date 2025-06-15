//
//  FeelingPlanetViewPresenter.swift
//

import Foundation

protocol FeelingPlanetViewPresenterDelegate: AnyObject {
    func didUpdate(viewModel: FeelingPlanetViewModel)
    func didUpdateSection(at index: IndexSet)
}

protocol FeelingPlanetViewPresenterType: AnyObject {
    var delegate: FeelingPlanetViewPresenterDelegate? { get set }
    func fetchData(isUpdate: Bool)
    func numberOfSectionsOnTableView() -> Int
}

class FeelingPlanetViewPresenter: FeelingPlanetViewPresenterType {
    weak var delegate: FeelingPlanetViewPresenterDelegate?
    private var loadedModel: FeelingPlanetViewModel = FeelingPlanetViewModel(isLoading: false) {
        didSet {
            delegate?.didUpdate(viewModel: loadedModel)
        }
    }
    private var isFetchingData: Bool = false
    private var dataAccessQueue = DispatchQueue(label: "feelingplanet_data", attributes: .concurrent)
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