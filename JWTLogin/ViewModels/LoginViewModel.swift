//
// Created by Ati on 2019-05-18.
// Copyright (c) 2019 Ati. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa

protocol PLoginViewModel {
    var username: BehaviorRelay<String> { get }
    var password: BehaviorRelay<String> { get }
    var loginBtnEnabled: Observable<Bool> { get }
    var loginRequest: PublishRelay<Void> { get }
    var loginRequestCompleted: Observable<Bool> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var showError: PublishRelay<String> { get }
}

class LoginViewModel: PLoginViewModel {
    var username: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    var password: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    var loginBtnEnabled: Observable<Bool> = Observable.never()
    var loginRequest: PublishRelay<Void> = PublishRelay<Void>()
    var loginRequestCompleted: Observable<Bool> = Observable.never()
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var showError: PublishRelay<String> = PublishRelay<String>()

    var disposeBag = DisposeBag()

    var authService: PAuthService!

    init(authService: PAuthService) {
        self.authService = authService

        loginBtnEnabled = Observable.combineLatest(username.asObservable(), password.asObservable()) {
            !$0.isEmpty && !$1.isEmpty
        }

        loginRequestCompleted = loginRequest.asObservable()
                .flatMapLatest { (_) -> Observable<Bool> in
                    self.isLoading.accept(true)

                    return self.authService
                            .login(username: self.username.value, password: self.password.value)
                            .asObservable()
                            .map { result in
                                self.isLoading.accept(false)
                                return result
                            }
                }
                .catchError { error -> Observable<Bool> in
                    self.isLoading.accept(false)

                    var errorMsg = ""

                    switch error {
                    case AuthError.notAuthorized:
                        errorMsg = "Invalid username or password."
                        break
                    default:
                        errorMsg = "Unexpected error."
                    }

                    self.showError.accept(errorMsg)

                    return Observable.error(error)
                }
                .retry()
    }
}