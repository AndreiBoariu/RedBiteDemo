//
//  NetworkDefinions.swift
//  RedBiteDemo
//
//  Created by Boariu Andy on 4/24/19.
//  Copyright © 2019 RedBite Inc. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

let k_UnexpectedErrorOccurred               = "Unexpected error occurred. Please contact support."

public enum RequestState: Error, Equatable {
    case completed(result: APIResponse)
    case error(message: String)
}

public func ==(lhs: RequestState, rhs: RequestState) -> Bool {
    switch (lhs, rhs) {
    case (.completed, .completed):
        return true
    case (.error, .error):
        return true
    default:
        return false
    }
}

public struct APIResponse {
    var success     = false
    var errorCode: Int?
    var message     = k_UnexpectedErrorOccurred
    var dictMessages = [String: JSON]()
    var data: JSON?
    
    var errorMessage: String {
        var arrMessages = [String]()
        
        for (_, value) in dictMessages {
            arrMessages.append(value.map { $1.stringValue }.joined(separator: "\n"))
        }
        
        return arrMessages.isEmpty ? message : arrMessages.joined(separator: "\n")
    }
    
    init() {
        
    }
    
    init(json: JSON?) {
        guard let json = json else { return }
        if let bSuccess = json["success"].bool {
            if bSuccess == true {
                self.success        = true
                data                = json["data"]
            }
            else {
                
                self.success        = false
                data                = nil
                
                //=>    Find error code
                if let iErrorCode = json["statusCode"].int {
                    errorCode               = iErrorCode
                }
                
                //=>    Change message
                if let arrErrors = json["data"]["errors"].array {
                    message = arrErrors.map { $0.stringValue }.joined(separator: "\n")
                }
            }
        }
    }
}

public extension MoyaProvider {
    public func requestJSON(_ token: Target) -> Single<RequestState> {
        return Single.create { [weak self] single in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case let .success(response):
                    do {
                        let jsonData = try JSON(data: response.data)
                        
                        //=>    ********************************************
                        //=>    Add these values manually
                        var json = JSON()
                        json["statusCode"].intValue = response.statusCode
                        json["success"].boolValue   = response.statusCode >= 400 ? false : true
                        
                        //=>    Add json to "data" key
                        json["data"]                = jsonData
                        //=>    ********************************************
                        
                        let apiResponse = APIResponse(json: json)
                        if apiResponse.success {
                            single(.success(RequestState.completed(result: apiResponse)))
                        }
                        else {
                            single(.success(RequestState.error(message: apiResponse.errorMessage)))
                        }
                    }
                    catch {
                        single(.success(RequestState.error(message: error.localizedDescription)))
                    }
                    
                case let .failure(error):
                    single(.success(RequestState.error(message: error.localizedDescription)))
                }
            }
            
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}
