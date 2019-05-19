//
//  RouterViewModelTests.swift
//  JWTLoginTests
//
//  Created by Ati on 2019. 05. 11..
//  Copyright © 2019. Ati. All rights reserved.
//

import XCTest
import Quick
import RxSwift
import RxBlocking
import Swinject
import SwinjectStoryboard
import Nimble
@testable import JWTLogin

class RouterViewModelSpec: QuickSpec {
    override func spec() {
        describe("RouterViewModel") {
            var sut: RouterViewModel!
            var mockTokenService: MockAuthService!
            
            beforeEach {
                self.registerDependencies()
                sut = SwinjectStoryboard.defaultContainer.resolve(PRouterViewModel.self) as? RouterViewModel
                mockTokenService = sut.authService as? MockAuthService
                guard sut != nil else {
                    return XCTFail("Cannot resolve PRouterViewModel from DI container")
                }
            }
            
            context("when refresh token request has called") {
                beforeEach {
                    _ = sut.refreshToken().asObservable().first()
                }
                
                it("tries to extend the token from the API") {
                    expect(mockTokenService.refreshTokenHasCalled).to(beTrue())
                }
            }
        }
    }
}

extension RouterViewModelSpec {
    func registerDependencies() {
        SwinjectStoryboard.defaultContainer.register(PAuthService.self) { resolver in
            return MockAuthService()
        }
        
        SwinjectStoryboard.defaultContainer.register(PRouterViewModel.self) { resolver in
            guard let tokenService = resolver.resolve(PAuthService.self) else {
                preconditionFailure("Missing dependency for RouterViewModel")
            }
            
            return RouterViewModel(authService: tokenService)
        }
    }
    
    class MockAuthService: PAuthService {
        var user: User?

        var refreshTokenHasCalled = false
        
        func refreshToken() -> Single<Bool> {
            refreshTokenHasCalled = true
            return Single.just(true)
        }

        func login(username: String, password: String) -> Single<Bool> {
            return Single.just(true)
        }
    }
}
