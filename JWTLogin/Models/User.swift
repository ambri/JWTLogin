//
//  User.swift
//  JWTLogin
//
//  Created by Ati on 2019. 05. 04..
//  Copyright © 2019. Ati. All rights reserved.
//
import JWTDecode

struct User: Decodable {
    let id: String
    let username: String
    let name: String
    let role: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idp:user_id"
        case username = "idp:user_name"
        case name = "idp:fullname"
        case role = "role"
    }
}
