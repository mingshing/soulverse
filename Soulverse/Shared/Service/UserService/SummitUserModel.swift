//
//  KonoUserModel.swift
//
//  Created by mingshing on 2021/12/8.
//


public struct SummitUserModel: Codable {
    
    let kid: UInt
    let platform: String
    let platformUid: String
    let primaryEmail: String
    let emailConfirmation: UInt
    let picture: String
    let nickname: String
    let isNew: Bool?
    let kpsKeyId: String?
    let kpsToken: String?
    var sessionToken: String?

    enum CodingKeys: String, CodingKey {
        case kid
        case platform
        case picture
        case nickname
        case platformUid = "platform_uid"
        case primaryEmail = "primary_email"
        case emailConfirmation = "email_confirmation"
        case isNew = "is_new"
        case kpsKeyId = "kps_key_id"
        case kpsToken = "token"
    }
    
}
