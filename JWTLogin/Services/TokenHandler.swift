//
//  TokenProvider.swift
//  JWTLogin
//
//  Created by Ati on 2019. 05. 08..
//  Copyright © 2019. Ati. All rights reserved.
//

import Foundation
import JWTDecode

protocol PTokenHandler {
    var accessToken: String { get }
    var refreshToken: String { get }
    
    func saveToken(_ token: Token) -> Bool
    func getUser() -> User
}

class TokenHandler: PTokenHandler {
    private var _store: TokenStore
    
    var accessToken: String { return _store.get(.access) }
    var refreshToken: String { return _store.get(.refresh) }
    
    init (store: TokenStore) {
        self._store = store
    }
    
    func saveToken(_ token: Token) -> Bool {
        return _store.save(token)
    }
    
    func getUser() -> User {
        let data = try! decode(jwt: accessToken)
        return User(
            id: data.body["idp:user_id"] as! String,
            username: data.body["idp:user_name"] as! String,
            name: data.body["idp:fullname"] as! String,
            role: data.body["role"] as! String)
    }
}
