//
//  LandingVM.swift
//  RedBiteDemo
//
//  Created by Boariu Andy on 4/24/19.
//  Copyright © 2019 RedBite Inc. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import SwiftyJSON

class LandingVM {
    let getTopMostContribuitors: Single<RequestState>
    
    init(githubAPI: GithubService) {
        getTopMostContribuitors = githubAPI.getTopMostContribuitors()
    }
}
