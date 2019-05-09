//
//  DataProvider.swift
//  JWTLogin
//
//  Created by Ati on 2019. 05. 08..
//  Copyright © 2019. Ati. All rights reserved.
//

import Foundation

enum TokenType: String {
    case access
    case refresh
}

protocol PTokenStore {
    func save(_ token: Token) -> Bool
    func get(_ type: TokenType) -> String
}

class TokenStore: PTokenStore {
    var tokenStoreSuite: String = "TokenSuite"
    var userDefaults: UserDefaults?
    
    init() {
        self.userDefaults = UserDefaults(suiteName: tokenStoreSuite)
    }
    
    func save(_ token: Token) -> Bool {
        userDefaults?.set(token.accessToken, forKey: TokenType.access.rawValue)
        userDefaults?.set(token.refreshToken, forKey: TokenType.refresh.rawValue)
        return true
    }
    
    func get(_ type: TokenType) -> String {
        switch type {
        case .access:
            return userDefaults?.string(forKey: TokenType.access.rawValue) ?? ""
        case .refresh:
            return userDefaults?.string(forKey: TokenType.refresh.rawValue) ?? ""
        }
    }
}
