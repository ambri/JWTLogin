//
// Created by Ati on 2019-05-19.
// Copyright (c) 2019 Ati. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SwinjectStoryboard
import RxSwift
@testable import JWTLogin

class LoginViewModelSpec: QuickSpec {
    override func spec() {
        describe("LoginViewModel") {
            var sut: LoginViewModel!
            var mockAuthService: MockAuthService!
            let disposeBag = DisposeBag()

            beforeEach {
                self.registerDependencies()
                sut = SwinjectStoryboard.defaultContainer.resolve(PLoginViewModel.self) as? LoginViewModel

                guard sut != nil,
                      let mas = (sut.authService as? MockAuthService) else {
                    preconditionFailure()
                }

                mockAuthService = mas
            }

            context("loginButton") {
                it("is disabled by default") {
                    sut.loginBtnEnabled.subscribe(onNext: { result in
                        expect(result).to(beFalse())
                    }).disposed(by: disposeBag)
                }

                it("is enabled if it got valid credentials") {
                    sut.loginBtnEnabled.skip(2).subscribe(onNext: { result in
                        expect(result).to(beTrue())
                    }).disposed(by: disposeBag)

                    sut.username.accept("attila.ambrus")
                    sut.password.accept("asd123")
                }

                it("is disabled if it got invalid credentials") {
                    sut.loginBtnEnabled.skip(2).subscribe(onNext: { result in
                        expect(result).to(beFalse())
                    }).disposed(by: disposeBag)

                    sut.username.accept("attila.ambrus")
                    sut.password.accept("")
                }
            }

            context("when login is requested") {
                it("signals to show activity indicator") {
                    var isLoadingCalled = false
                    sut.isLoading.skip(1).subscribe(onNext: { val in
                        if val {
                            isLoadingCalled = true
                        }
                    }).disposed(by: disposeBag)
                    sut.loginRequestCompleted.subscribe().disposed(by: disposeBag)
                    sut.loginRequest.accept(())
                    expect(isLoadingCalled).to(beTrue())
                }

                it("calls the login process with the give username and password") {
                    sut.loginRequestCompleted.subscribe().disposed(by: disposeBag)
                    sut.loginRequest.accept(())
                    expect(mockAuthService.loginHasCalled).to(beTrue())
                }

                context("when login was successful") {
                    it("signals to hide activity indicator") {
                        var isLoadingCalled = 0
                        sut.isLoading.skip(1).subscribe(onNext: { val in
                            isLoadingCalled += 1
                        }).disposed(by: disposeBag)
                        sut.loginRequestCompleted.subscribe().disposed(by: disposeBag)
                        sut.loginRequest.accept(())
                        expect(isLoadingCalled).to(equal(2))
                    }
                }

                context("when login was unsuccessful") {
                    beforeEach {
                        mockAuthService.shouldThrowAnError = true
                    }

                    it("signals to hide activity indicator") {
                        var isLoadingCalled = 0
                        sut.isLoading.skip(1).subscribe(onNext: { val in
                            isLoadingCalled += 1
                        }).disposed(by: disposeBag)
                        sut.loginRequestCompleted.subscribe().disposed(by: disposeBag)
                        sut.loginRequest.accept(())
                        expect(isLoadingCalled).to(equal(2))
                    }

                    it("shows wrong credentials error when the credentials are invalid") {
                        mockAuthService.errorType = AuthError.notAuthorized
                        sut.showError.subscribe(onNext: { msg in
                            expect(msg).to(equal("Invalid username or password."))
                        }).disposed(by: disposeBag)
                        sut.loginRequestCompleted.subscribe().disposed(by: disposeBag)
                        sut.loginRequest.accept(())
                    }
                }
            }
        }
    }
}

extension LoginViewModelSpec {
    func registerDependencies() {
        SwinjectStoryboard.defaultContainer.register(PLoginViewModel.self) { resolver in
            return LoginViewModel(authService: resolver.resolve(PAuthService.self)!)
        }

        SwinjectStoryboard.defaultContainer.register(PAuthService.self) { resolver in
            return MockAuthService()
        }
    }

    class MockAuthService: PAuthService {
        var user: User?

        var loginHasCalled = false
        var shouldThrowAnError = false
        var errorType: Error?

        func refreshToken() -> Single<Bool> {
            fatalError("refreshToken() has not been implemented")
        }

        func login(username: String, password: String) -> Single<Bool> {
            loginHasCalled = true

            if shouldThrowAnError {
                return Single.error(errorType ?? AuthError.notAuthorized)
            }

            return Single.just(true)
        }
    }
}