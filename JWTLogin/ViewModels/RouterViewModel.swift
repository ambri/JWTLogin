//
//  RouterViewModel.swift
//  JWTLogin
//
//  Created by Ati on 2019. 05. 10..
//  Copyright © 2019. Ati. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol PRouterViewModel {
    var refreshResult: Bool { get set }
    func refreshToken() -> Single<Bool>
}

class RouterViewModel: PRouterViewModel {
    let authService: PAuthService
    var refreshResult: Bool = false
    
    init(authService: PAuthService) {
        self.authService = authService
    }

    func refreshToken() -> Single<Bool> {
        return authService.refreshToken()
    }
}
