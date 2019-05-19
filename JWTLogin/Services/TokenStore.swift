//
//  DataProvider.swift
//  JWTLogin
//
//  Created by Ati on 2019. 05. 08..
//  Copyright © 2019. Ati. All rights reserved.
//

import Foundation

enum TokenError: String, Error {
    case notFound
}

protocol PTokenStore {
    func save(_ token: Token) -> Bool
    func get() -> Token?
    func clear()
}

class TokenStore: PTokenStore {
    private var _tokenKey = "tokenKey"
    private var _tokenStoreSuite: String = "tokenSuite"
    var userDefaults: UserDefaults!
    
    init() {
        self.create()
    }

    private func create() {
        userDefaults = UserDefaults(suiteName: _tokenStoreSuite)
    }
    
    func save(_ token: Token) -> Bool {
        let encoder = JSONEncoder()
        userDefaults.set(try! encoder.encode(token), forKey: _tokenKey)
        return true
    }
    
    func get() -> Token? {
        guard let json = userDefaults.string(forKey: _tokenKey) else {
            return nil
        }

        return try! JSONDecoder().decode(Token.self, from: json.data(using: .utf8)!)
    }
    
    func clear() {
        userDefaults.removeSuite(named: _tokenStoreSuite)
        create()
    }
}
