//
//  GithubAPI.swift
//  RedBiteDemo
//
//  Created by Boariu Andy on 4/24/19.
//  Copyright © 2019 RedBite Inc. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

enum GithubAPI {
    case getRepositories()
}

extension GithubAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com/")!
    }
    
    var path: String {
        switch self {
            
        case .getRepositories:
            return "repos/vsouza/awesome-ios/contributors"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .getRepositories():
            return .requestParameters(parameters: ["page": 1,
                                                   "per_page" : 25],
                                      encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let headers = ["Content-type": "application/x-www-form-urlencoded",
                       "Accept": "application/json"]
        
        switch self {
            
        default:
            return headers
        }
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
