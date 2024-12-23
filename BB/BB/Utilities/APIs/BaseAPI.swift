//
//  BaseAPI.swift
//  BB
//
//  Created by ha van dong on 12/11/24.
//

import Foundation
import SwiftyJSON
import Alamofire

let root = "https://uatapi.b2b-vietnam.com"
enum Endpoint {
    case auth
    case venues
    
    var path: String {
        switch self {
        case .auth: return "/auth"
        case .venues: return "/auth"
        }
    }
}

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
    var errorObj: ErrorModel?
    var json: JSON?
    
    init(withError error: ErrorModel) {
        self.errorObj = error
    }
    
    init(withData jsonData: JSON) {
        self.json = jsonData
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

enum BBApiStatus: Int {
    case badRequest = 400
    case authMiss = 401
    case notFound = 404
    case unsuportMedia = 415
    case success = 200
}

enum BBStatusCode: String {
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

class IAPIRequest {
    let BaseURL = AppConfigs.shared.rootUrl//: String = "https://dzgo5h8a1025l.cloudfront.net/"
    
    func excuteRequest(_ api: IAPIModel, isAutoLoading: Bool = false, isAutoHandleError: Bool = false, completion: @escaping (HttpResults) -> Void) {
        excuteRequest(api, isAutoLoading: isAutoLoading, isAutoHandleError: isAutoHandleError, tranformType: DefaultTranForm.self) { result in
            completion(result)
        }
    }
    
    func excuteRequest<T, I: ITransform>(_ api: IAPIModel, isAutoLoading: Bool = false, isAutoHandleError: Bool = false, tranformType: I.Type, completion: @escaping (T) -> Void) where I.T == T {
        if isAutoLoading {
            BBLoading.showLoading()
        }
        
        self.sendRequest(toURL: api.url, bodyParam: api.params, urlQueryParam: api.query, useMethod: api.method) { result in
            let val = tranformType.tranform(result: result)
            completion(val)
            
            if isAutoLoading {
                BBLoading.hideLoading()
            }
            
            if isAutoHandleError, let error = result.errorObj {
                AppDelegate.shared.rootViewController.handleApiResponseError(errorModel: error)
            }
        }
    }
    
    func executeAutoDecodeRequest(url: String, method: HttpMethod, queryParams: [String: String] = [:], params: [String: Any] = [:], isAutoLoading: Bool = false, isAutoHandleError: Bool = false, completion: @escaping (HttpResults) -> Void) {
        executeAutoDecodeRequest(url: url, method: method, queryParams: queryParams, params: params, tranformType: DefaultTranForm.self) { result in
            completion(result)
        }
    }
    func executeAutoDecodeRequest<T, I: ITransform>(url: String, method: HttpMethod, queryParams: [String: String] = [:], params: [String: Any] = [:], isAutoLoading: Bool = false, isAutoHandleError: Bool = false, tranformType: I.Type, completion: @escaping (T) -> Void) where I.T == T {
        if isAutoLoading {
            BBLoading.showLoading()
        }
        
        self.sendRequest(toURL: url, bodyParam: params, urlQueryParam: queryParams, useMethod: method) { result in
            let val = tranformType.tranform(result: result)
            completion(val)
            
            if isAutoLoading {
                BBLoading.hideLoading()
            }
            
            if isAutoHandleError, let error = result.errorObj {
                AppDelegate.shared.rootViewController.handleApiResponseError(errorModel: error)
            }
        }
    }
    
    func sendRequest(toURL url: String, bodyParam params: [String : Any]?, urlQueryParam urlParams: [String : Any]?, useMethod httpMethod: HttpMethod, _ isEnableEncodingVal: Bool = true, completion: @escaping (_ result: HttpResults) -> Void) {
        //        if NetworkMonitor.shared.isReachable && UserSettings.shared.lostConnectInfo.isNotEmpty {
        //            let infos = UserSettings.shared.lostConnectInfo.components(separatedBy: AppConstant.kSeparateDataApi)
        //            if infos.count > 1 {
        //                let propeties = [LogActionMonitorParamName.apiName.rawValue: infos.first!, LogActionMonitorParamName.timeRes.rawValue: infos[1]]
        //                LogActionUtils.logCallbackEvent(feature: .apiError, actionName: LogActionMonitorControlValue.callApiLostConnect.rawValue, properties: propeties)
        //            }
        //            UserSettings.shared.removeLostConnectInfo()
        //        }
    }
}

class AppRequester: IAPIRequest {
    override func sendRequest(toURL url: String, bodyParam params: [String : Any]?, urlQueryParam urlParams: [String : Any]?, useMethod httpMethod: HttpMethod, _ isEnableEncodingVal: Bool = true, completion: @escaping (_ result: HttpResults) -> Void) {
        
        var method: HTTPMethod = .get
        switch httpMethod {
        case .get: method = HTTPMethod.get
        case .post: method = HTTPMethod.post
        case .put: method = HTTPMethod.put
        case .patch: method = HTTPMethod.patch
        case .delete: method = HTTPMethod.delete
            
        }
        
        let headers: HTTPHeaders = [
            .accept("application/json")
        ]
        
        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.prettyPrinted, headers: headers).responseJSON { response in
            debugPrint(response)
            
            if let error = response.error {
                var errorModel = ErrorModel()

                if error.responseCode == 500 {
                    errorModel.errorMessage = "Server Error".localized()
                }
                else if error.responseCode == 404 {
                    errorModel.errorMessage = "Api Not found".localized()
                }
                completion(HttpResults(withError: errorModel))
                return
            }
            
            if let data = response.data {
                if let json = try? JSON(data) {
                    completion(HttpResults(withData: json))
                } else {
                    let message = String(data: data, encoding: .utf8)
                    var error = ErrorModel()
                    error.errorMessage = message ?? ""
                    completion(HttpResults(withError: error))
                }
                
            } else {
                completion(HttpResults(withError: ErrorModel()))
            }
        }
    }
}
