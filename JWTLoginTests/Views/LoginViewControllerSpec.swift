//
// Created by Ati on 2019-05-17.
// Copyright (c) 2019 Ati. All rights reserved.
//

import Quick
import Nimble
import SwinjectStoryboard
import RxCocoa
import RxSwift
@testable import JWTLogin

class LoginViewControllerSpec: QuickSpec {
    override func spec() {
        describe("LoginViewController") {
            var sut: LoginViewController!
            var viewModel: MockLoginViewModel!

            beforeEach {
                self.registerDependencies()
                sut = SwinjectStoryboard.create(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController

                guard sut != nil,
                      let vm = sut.viewModel as? MockLoginViewModel else {
                    preconditionFailure()
                }

                viewModel = vm

                triggerViewDidAppear(sut)
            }

            context("when the view has loaded") {
                context("usernameField") {
                    it("has proper placeholder string") {
                        expect(sut.usernameField.placeholder).to(equal("Username"))
                    }

                    it("updates viewModel if a user typed his/her username") {
                        sut.usernameField.sendEditingChanged(withText: "attila.ambrus")
                        expect(viewModel.username.value).to(equal("attila.ambrus"))
                    }
                }

                context("passwordField") {
                    it("has proper placeholder string") {
                        expect(sut.passwordField.placeholder).to(equal("Password"))
                    }

                    it("updates viewModel if a user typed his/her password") {
                        sut.passwordField.sendEditingChanged(withText: "asd123")
                        expect(viewModel.password.value).to(equal("asd123"))
                    }
                }

                context("loginBtn") {
                    it("has proper title") {
                        expect(sut.loginBtn.titleLabel?.text).to(equal("Login"))
                    }

                    it("should be disabled") {
                        expect(sut.loginBtn.isEnabled).to(beFalse())
                    }

                    it("should be enabled if username and password has been filled") {
                        viewModel.expectedLoginButtonStatus(status: true)
                        expect(sut.loginBtn.isEnabled).to(beTrue())
                    }

                    it("should trigger the login request when it pressed") {
                        sut.loginBtn.sendActions(for: .touchUpInside)
                        expect(viewModel.loginRequestHasCalled).to(beTrue())
                    }
                }

                context("loadingView") {
                    it("should be hidden") {
                        expect(sut.loadingView.isHidden).to(beTrue())
                    }
                }

                context("showPasswordButton") {
                    it("should be off") {
                        expect(sut.showPassSwitch.isOn).to(beFalse())
                    }

                    it("shows or hide password") {
                        let oldValue = sut.passwordField.isSecureTextEntry
                        sut.showPassSwitch.isOn = true
                        sut.showPassSwitch.sendActions(for: .valueChanged)
                        expect(sut.passwordField.isSecureTextEntry).to(equal(!oldValue))
                    }
                }
            }

            // login actionkor megjelenést nem kell tesztelni???
            context("when the viewModel signals to show activity") {
                it("shows an activity indication") {
                    viewModel.expectedIsLoading(isLoading: true)
                    expect(sut.loadingView.isHidden).to(beFalse())
                }
            }

            context("when the viewModel signals to hide activity") {
                it("hides the activity indication") {
                    viewModel.expectedIsLoading(isLoading: false)
                    expect(sut.loadingView.isHidden).to(beTrue())
                }
            }

            // ?????
            context("when the login has requested") {
                context("and it was not success") {
                    it("should show an error message") {
                        presentAsInitialViewController(sut)
                        let msg = "Unexpected error."
                        viewModel.expectedErrorMessage(msg: msg)
                        expect(sut.presentedViewController).to(beAnInstanceOf(UIAlertController.self))
                        expect((sut.presentedViewController as? UIAlertController)?.message ?? "").to(equal(msg))
                    }
                }

                context("and it was successful") {
                    it("should show the Home view") {
                        presentAsInitialViewController(sut)
                        viewModel.expectedLoginResult(status: true)
                        expect(sut.presentedViewController).to(beAnInstanceOf(HomeViewController.self))
                    }
                }
            }
        }
    }
}

extension LoginViewControllerSpec {
    func registerDependencies() {
        SwinjectStoryboard.defaultContainer.register(PLoginViewModel.self) { resolver in
            return MockLoginViewModel()
        }

        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(LoginViewController.self) { r, c in
            c.viewModel = r.resolve(PLoginViewModel.self)
        }
    }

    class MockLoginViewModel: PLoginViewModel {
        var loginRequestCompleted: Observable<Bool> {
            return loginRequestCompletedSubject.asObservable()
        }

        var username: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
        var password: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
        var loginBtnEnabled: Observable<Bool> {
            return loginButtonEnabledSubject.asObservable()
        }
        var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
        var loginRequest: PublishRelay<Void> = PublishRelay<Void>()
        var showError: PublishRelay<String> = PublishRelay<String>()

        var loginRequestHasCalled = false
        var loginButtonEnabledSubject: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)
        var loginRequestCompletedSubject: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)

        var disposeBag = DisposeBag()

        init() {
            loginRequest += { _ in
                self.loginRequestHasCalled = true
            } => self.disposeBag
        }

        func expectedLoginResult(status: Bool) {
            loginRequestCompletedSubject.onNext(status)
        }

        func expectedLoginButtonStatus(status: Bool) {
            loginButtonEnabledSubject.onNext(status)
        }

        func expectedIsLoading(isLoading: Bool) {
            self.isLoading.accept(isLoading)
        }

        func expectedErrorMessage(msg: String) {
            showError.accept(msg)
        }
    }
}