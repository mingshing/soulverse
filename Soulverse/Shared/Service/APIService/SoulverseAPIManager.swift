//
//  SoulverseAPIManager.swift
//  Soulverse
//
//  Created by mingshing on 2021/12/8.
//

import Foundation
import Moya

// MARK: - API Environment Configuration
enum APIEnvironment {
    case production
    case development
    case mock
    
    var baseURL: String {
        switch self {
        case .production:
            return "https://summit.thekono.com/api"
        case .development:
            return "https://summit-dev.thekono.com/api"
        case .mock:
            return "https://mock.soulverse.com/api"
        }
    }
}

// MARK: - Soulverse API Manager
class SoulverseAPIManager {
    static let shared = SoulverseAPIManager()
    
    private var currentEnvironment: APIEnvironment = {
        #if Dev
        return .development
        #else
        return .production
        #endif
    }()
    
    private var isMockEnabled: Bool = false
    
    // MARK: - Providers
    lazy var userProvider: MoyaProvider<UserAPIService> = {
        return createProvider()
    }()
    
    lazy var notificationProvider: MoyaProvider<NotificationAPIService> = {
        return createProvider()
    }()
    
    private init() {}
    
    // MARK: - Configuration Methods
    func enableMockMode() {
        isMockEnabled = true
        refreshProviders()
    }
    
    func disableMockMode() {
        isMockEnabled = false
        refreshProviders()
    }
    
    func setEnvironment(_ environment: APIEnvironment) {
        currentEnvironment = environment
        refreshProviders()
    }
    
    var isUsingMockData: Bool {
        return isMockEnabled || currentEnvironment == .mock
    }
    
    // MARK: - Private Methods
    private func createProvider<T: TargetType>() -> MoyaProvider<T> {
        if isUsingMockData {
            return MoyaProvider<T>(stubClosure: MoyaProvider.delayedStub(0.5))
        } else {
            return MoyaProvider<T>()
        }
    }
    
    private func refreshProviders() {
        userProvider = createProvider()
        notificationProvider = createProvider()
    }
}

// MARK: - Updated APIService Extensions for Soulverse
extension UserAPIService {
    var soulverseBaseURL: URL {
        return URL(string: SoulverseAPIManager.shared.isUsingMockData ? 
                  APIEnvironment.mock.baseURL : 
                  HostAppContants.serverUrl)!
    }
}

extension NotificationAPIService {
    var soulverseBaseURL: URL {
        return URL(string: SoulverseAPIManager.shared.isUsingMockData ? 
                  APIEnvironment.mock.baseURL : 
                  HostAppContants.serverUrl)!
    }
}