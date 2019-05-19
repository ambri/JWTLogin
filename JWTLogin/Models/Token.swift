//
//  Token.swift
//  JWTLogin
//
//  Created by Ati on 2019. 05. 04..
//  Copyright © 2019. Ati. All rights reserved.
//
import Foundation

struct Token: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }
}
