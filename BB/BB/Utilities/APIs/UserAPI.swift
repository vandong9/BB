//
//  UserAPI.swift
//  BB
//

import Foundation

enum UserAPI {
    case verifyUserInfo
    
    var api: BaseAPIModel {
        switch self {
        case .verifyUserInfo:
            return BaseAPIModel(url: "", method: .post, query: [:], params: [:])
        }
    }
}
