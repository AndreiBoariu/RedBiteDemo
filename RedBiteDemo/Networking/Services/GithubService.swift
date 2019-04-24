//
//  GithubService.swift
//  RedBiteDemo
//
//  Created by Boariu Andy on 4/24/19.
//  Copyright © 2019 RedBite Inc. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

let githubProvider = MoyaProvider<GithubAPI>(plugins:[
        NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)
    ])

struct GithubService {
    private let provider: MoyaProvider<GithubAPI>
    
    init(provider: MoyaProvider<GithubAPI> = githubProvider) {
        
        self.provider = provider
    }
    
    func getTopMostContribuitors() -> Single<RequestState> {
        return provider
            .requestJSON(.getRepositories())
            .do(onSuccess: { requestState in
                if case let .completed(apiResponse) = requestState {
                    if let jsonData = apiResponse.data {
                    }
                }
            })
    }
}
