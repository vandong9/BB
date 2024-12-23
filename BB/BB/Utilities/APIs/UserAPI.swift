//
//  UserAPI.swift
//  BB
//

import Foundation


enum UserAPI {
    case verifyUserInfo(info: [String: String])
    
    var api: BaseAPIModel {
        switch self {
        case .verifyUserInfo(let info):
            return BaseAPIModel(url: root +  Endpoint.auth.path + "/register", method: .post, query: [:], params: info)
        }
    }
}
