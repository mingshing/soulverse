//
//  UserMock.swift
//

import Foundation
@testable import Soulverse

final class UserMock: UserProtocol {
    var userId: String? = "123456"
    var email: String? = "test@gmail.com"
    var registerChannel: String? = "email"
    var isLoggedin: Bool = true
    var isVerified: Bool = true
    var hasGrantedNotification: Bool = true
}
