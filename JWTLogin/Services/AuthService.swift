//
//  ApiService.swift
//  JWTLogin
//
//  Created by Ati on 2019. 05. 11..
//  Copyright © 2019. Ati. All rights reserved.
//

import Moya
import RxSwift
import JWTDecode

enum AuthError: String, Error {
    case notAuthorized
    case undeterminedUserFromToken
    case tokenSaveFailed
}

protocol PAuthService {
    var user: User? { get }
    func refreshToken() -> Single<Bool>
    func login(username: String, password: String) -> Single<Bool>
}

class AuthService: PAuthService {
    var user: User? {
        return nil
    }

    let tokenStore: PTokenStore
    let api: MoyaProvider<MultiTarget>

    init(tokenStore: PTokenStore, api: MoyaProvider<MultiTarget>) {
        self.tokenStore = tokenStore
        self.api = api
    }

    func refreshToken() -> Single<Bool> {
        guard let token = tokenStore.get() else {
            return Single.just(false)
        }

        return api.rx.request(MultiTarget(AuthApi.refreshToken(
                        data: RefreshTokenData(refreshToken: token.refreshToken,
                                grantType: "refresh_token",
                                clientId: ""))))
                .map({ (resp: Response) -> Response in
                    if resp.statusCode >= 400 {
                        throw AuthError.notAuthorized
                    }

                    return resp
                })
                .map(Token.self, using: JSONDecoder())
                .flatMap { token -> Single<Bool> in
                    if !self.tokenStore.save(token) {
                        throw AuthError.tokenSaveFailed
                    }

                    guard let token = self.tokenStore.get() else {
                        throw AuthError.notAuthorized
                    }

                    let user = try decode(jwt: token.accessToken)

                    guard let id = (user.body["idp:user_id"] as? String), !id.isEmpty else {
                        return Single.just(false)
                    }

                    return Single.just(true)
                }
                .catchError { error in
                    return Single.just(false)
                }
    }

    func login(username: String, password: String) -> Single<Bool> {
        return Single.just(true)
    }
}
