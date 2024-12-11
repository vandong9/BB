//
//  BaseAPI.swift
//  BB
//
//  Created by ha van dong on 12/11/24.
//

import Foundation
import SwiftyJSON

protocol SwiftyJSONMappable {
    init?(json: JSON)
}

struct ErrorModel: Error {
    var errorCode: String = ""
    var errorTitle: String = ""
    var errorMessage:String = ""
    var isShowError = true
    var requestURL: String = ""
    var extra: [String: Any] = [:]
    // Add more (Support Unity)
    var needGetWording: Bool = true

    static func noDataError() -> ErrorModel {
        return ErrorModel(errorCode: "", errorTitle: "AppLocalize.cmUnknownErrorTitle.toLocalize()", errorMessage: "AppLocalize.cmUnknownErrorMsg.toLocalize()", isShowError: false, requestURL: "", extra: [:], needGetWording: false)
    }
    
    var wrapTitle: String {
        return ""
    }
    
    var wrapMessage: String {
        return errorMessage ?? ""
    }
//
//    static func wrongOtpError() -> ErrorModel {
//        return ErrorModel(errorCode: "", errorTitle: "t_OTPKP10", errorMessage: "m_OTPKP10", isShowError: true, requestURL: "", extra: [:], needGetWording: true)
//    }
}

struct HttpResults {
    var requestId: String = ""
    var errorObj: ErrorModel?
    var json: JSON?
    
    init(withError error: ErrorModel, requestId: String = "") {
        self.errorObj = error
        self.requestId = requestId
    }
    
    init(withData jsonData: JSON, requestId: String = "") {
        self.json = jsonData
        self.requestId = requestId
    }
    
    var dataObject: JSON? {
        guard let json = json else { return nil }
        
        let dataJson = json[AppConstant.kDatakey]
        if dataJson.exists(), !dataJson.isNull {
            return dataJson
        }
        return nil
    }
    
    var resultObject: Result<JSON, ErrorModel> {
        if let errorObj = errorObj {
            return .failure(errorObj)
        }
        
        if let dataObject = dataObject {
            return .success(dataObject)
        }
        
        return .failure(ErrorModel.noDataError())
    }
    
    func decodeObject<T: SwiftyJSONMappable>() -> (T?, ErrorModel?) {
        var instance: T?
        if let data = dataObject, !data.isNull {
             instance =  T.init(json: data)
        }
        if let error = errorObj {
            return (instance, error)
        }
        if let instance = instance {
            return (instance, nil)
        } else {
            return (nil, ErrorModel.noDataError())
        }
    }

    func resultDecodeObject<T: SwiftyJSONMappable>() -> Result<T, ErrorModel> {
        if let errorObj = errorObj {
            return .failure(errorObj)
        }
        
        if let dataObject = dataObject {
            if let instance =  T.init(json: dataObject) {
                return .success(instance)
            }
        }
        
        return .failure(ErrorModel.noDataError())
        
        ///
        ///Ex:   let instance: Result<BaseModel, ErrorModel> = result.resultDecodeObject<BaseModel>()
        ///
    }
}

enum VIBApiStatus: Int {
    case badRequest = 400
    case authMiss = 401
    case notFound = 404
    case unsuportMedia = 415
    case success = 200
}

enum VIBStatusCode: String {
    case success = "000000"
}

public enum HttpMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

protocol IAPIModel {
    var url: String {get set}
    var method: HttpMethod  {get set}
    var query: [String: String]  {get set}
    var params: [String: Any]  {get set}

}
struct BaseAPIModel: IAPIModel {
    var url: String
    var method: HttpMethod
    var query: [String: String]
    var params: [String: Any]
}

typealias decodedCompletion<T: SwiftyJSONMappable> = (_ data: T?, _ error: ErrorModel?)-> Void
typealias decodedResultCompletion<T: SwiftyJSONMappable> = (Result<T, ErrorModel>)-> Void

protocol ITransform {
    associatedtype T
    static func tranform(result: HttpResults) -> T
}

class DefaultTranForm: ITransform {
    typealias T = HttpResults
    static func tranform(result: HttpResults) -> T {
        return result
    }
}

class DecodedTranform<E: SwiftyJSONMappable>: ITransform {
    typealias T = (E?, ErrorModel?)
    static func tranform(result: HttpResults) -> T {
        let decoded: T = result.decodeObject()
        return decoded
    }
}

class DecodedResultTranform<E: SwiftyJSONMappable>: ITransform {
    typealias T = Result<E, ErrorModel>
    static func tranform(result: HttpResults) -> T {
        let decoded: T = result.resultDecodeObject()
        return decoded
    }
}

extension JSON {
    public var isNull: Bool {
        get {
            return self.type == .null;
        }
    }
    
    public var isExistAndNotNull: Bool {
        return self.exists() && !self.isNull
    }
}
