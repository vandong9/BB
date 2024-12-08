//
//  UserSession.swift
//  BB
//

import Foundation

class UserSession {
    static let shared = UserSession()

    private(set) var accessToken: String?
}
