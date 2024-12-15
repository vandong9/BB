//
//  RegisterRepositoryImpl.swift
//  BB
//

import Foundation

class RegisterRepositoryImpl {
    var requester = IAPIRequest()
    
    static let instance: RegisterRepositoryImpl = RegisterRepositoryImpl()
}

extension RegisterRepositoryImpl: RegisterInputInfoVC.Repository {
    func checkInfo(infos: [String: String], completion: @escaping (ErrorModel?) -> Void) {
//        requester.excuteRequest(UserAPI.verifyUserInfo.api) { result in
//            
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(nil)
        }
    }
}



extension RegisterRepositoryImpl: RegisterInputPinVC.Repository {
    func verifyPin(infos: [String : String], completion: @escaping (ErrorModel?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(nil)
        }
    }
}


extension RegisterRepositoryImpl: RegisterCardInfoCardVC.Repository {
    func submit(infos: [String : String], completion: @escaping (ErrorModel?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(nil)
        }
    }
}
