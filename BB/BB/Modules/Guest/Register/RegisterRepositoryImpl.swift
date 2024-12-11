//
//  RegisterRepositoryImpl.swift
//  BB
//

import Foundation

class RegisterRepositoryImpl {
    static let instance: RegisterRepositoryImpl = RegisterRepositoryImpl()
}

extension RegisterRepositoryImpl: RegisterInputInfoVC.Repository {
    func checkInfo(infos: [String: String], completion: @escaping (ErrorModel?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(nil)
        }
    }
}

