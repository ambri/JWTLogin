//
//  ApiServiceTests.swift
//  JWTLoginTests
//
//  Created by Ati on 2019. 05. 11..
//  Copyright © 2019. Ati. All rights reserved.
//

import XCTest
import Quick
import SwinjectStoryboard
import RxBlocking
import Nimble
import Moya
@testable import JWTLogin

class AuthServiceSpec: QuickSpec {
    private var expectedRefreshTokenResponse: EndpointSampleResponse = .networkResponse(502, Data())

    override func spec() {
        describe("AuthService") {
            var sut: AuthService!
            var mockTokenStore: MockTokenStore!

            beforeEach {
                self.registerDependencies()
                sut = SwinjectStoryboard.defaultContainer.resolve(PAuthService.self) as? AuthService
                guard sut != nil else {
                    return XCTFail("Cannot resolve PTokenService from DI container")
                }

                mockTokenStore = sut.tokenStore as? MockTokenStore

                mockTokenStore.clear()
            }

            context("when refreshing token") {
                context("when token refreshing was success") {
                    beforeEach {
                        self.expectedRefreshTokenResponse = .networkResponse(200, FakeJsons.token.rawValue.data(using: .utf8)!)
                        mockTokenStore.tokenExists = true
                        _ = try! sut.refreshToken().toBlocking().first()!
                    }

                    it("tries to get the stored token from the cache") {
                        expect(mockTokenStore.tokenGetterHasCalled).to(beTrue())
                    }

                    it("tries to save the got token") {
                        expect(mockTokenStore.tokenSavingHasCalled).to(beTrue())
                    }
                }

                context("when token refreshing has failed") {
                    it("returns false if there is no token in the store") {
                        mockTokenStore.tokenExists = false
                        self.expectedRefreshTokenResponse = .networkResponse(200, FakeJsons.token.rawValue.data(using: .utf8)!)
                        let result = try! sut.refreshToken().toBlocking().first()!
                        expect(result).to(beFalse())
                    }

                    it("returns false if the backend refuses to extend the old authentication") {
                        mockTokenStore.tokenExists = true
                        self.expectedRefreshTokenResponse = .networkResponse(401, Data())
                        let result = try! sut.refreshToken().toBlocking().first()!
                        expect(result).to(beFalse())
                    }

                    it("returns false if got empty or wrong access token") {
                        mockTokenStore.tokenExists = true
                        self.expectedRefreshTokenResponse = .networkResponse(200, FakeJsons.wrongToken.rawValue.data(using: .utf8)!)
                        let result = try! sut.refreshToken().toBlocking().first()!
                        expect(result).to(beFalse())
                    }
                }
            }
        }
    }
}

extension AuthServiceSpec {
    func registerDependencies() {
        SwinjectStoryboard.defaultContainer.register(PAuthService.self) { resolver in
            guard let tokenStore = resolver.resolve(PTokenStore.self),
                    let moya = resolver.resolve(MoyaProvider<MultiTarget>.self) else {
                preconditionFailure("Missing dependency for RouterViewModel")
            }

            return AuthService(tokenStore: tokenStore, api: moya)
        }.inObjectScope(.container)

        SwinjectStoryboard.defaultContainer.register(PTokenStore.self) { resolver in
            return MockTokenStore()
        }.inObjectScope(.container)

        SwinjectStoryboard.defaultContainer.register(MoyaProvider<MultiTarget>.self) { _ in
            return MoyaProvider<MultiTarget>(
                    endpointClosure: self.createStubEndpoint,
                    stubClosure: MoyaProvider.immediatelyStub)
        }.inObjectScope(.container)
    }

    class MockTokenStore: PTokenStore {
        var tokenExists = false
        var isSaveSuccess = true
        var tokenGetterHasCalled = false
        var tokenSavingHasCalled = false

        private var storedToken: Token? = nil

        func get() -> Token? {
            tokenGetterHasCalled = true

            if !tokenExists {
                return nil
            }

            tokenSavingHasCalled = true

            guard let token = storedToken else {
                return try! JSONDecoder().decode(Token.self, from: FakeJsons.token.rawValue.data(using: .utf8)!)
            }

            return token
        }

        func save(_ token: Token) -> Bool {
            storedToken = token
            return isSaveSuccess
        }

        func clear() {

        }
    }

    func createStubEndpoint(withTarget target: MultiTarget) -> Endpoint {
        var sampleResponseClosure: Endpoint.SampleResponseClosure
        switch target.target {
        case AuthApi.refreshToken:
            sampleResponseClosure = {self.expectedRefreshTokenResponse}
        default:
            sampleResponseClosure = {.networkResponse(502, Data())}
        }
        return Endpoint(
                url: target.baseURL.absoluteString,
                sampleResponseClosure: sampleResponseClosure,
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers)
    }
}
