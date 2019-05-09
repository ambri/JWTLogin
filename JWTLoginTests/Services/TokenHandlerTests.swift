//
//  TokenHandlerTests.swift
//  JWTLoginTests
//
//  Created by Ati on 2019. 05. 08..
//  Copyright © 2019. Ati. All rights reserved.
//

import XCTest
import Foundation
@testable import JWTLogin

class TokenHandlerTests: XCTestCase {
    private var _fakeToken = Token(
        accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZHA6dXNlcl9pZCI6IjUwYTdkYTFkLWZlMDctNGMxNC04YjFiLTAwNzczN2Y0Nzc2MyIsImlkcDp1c2VyX25hbWUiOiJqZG9lIiwiaWRwOmZ1bGxuYW1lIjoiSm9obiBEb2UiLCJyb2xlIjoiZWRpdG9yIiwiZXhwIjoxNTU2NDc2MjU1fQ.iqFmotBtfAYLplfpLVh_kPgvOIPyV7UMm-NZA06XA5I",
        tokenType: "bearer",
        expiresIn: 119,
        refreshToken: "NTBhN2RhMWQtZmUwNy00YzE0LThiMWItMDA3NzM3ZjQ3NzYzIyNkNmQ5OTViZS1jY2IxLTQ0MGUtODM4NS1lOTkwMTEwMzBhYzA=")
    private var _fakeUser = User(
        id: "50a7da1d-fe07-4c14-8b1b-007737f47763",
        username: "jdoe",
        name: "John Doe",
        role: "editor")
    private var _tokenHandler: TokenHandler!

    override func setUp() {
        _tokenHandler = TokenHandler(store: MockTokenStore())
    }

    override func tearDown() {
        
    }
    
    func test_Token_Save() {
        guard _tokenHandler.saveToken(_fakeToken) else {
            return XCTFail("Token save unsuccessful.")
        }
        
        XCTAssertEqual(_tokenHandler.accessToken, _fakeToken.accessToken)
        XCTAssertEqual(_tokenHandler.refreshToken, _fakeToken.refreshToken)
    }
    
    func test_Get_UserData() {
        guard _tokenHandler.saveToken(_fakeToken) else {
            return XCTFail("Token save unsuccessful.")
        }
        
        let userData = _tokenHandler.getUser()
        XCTAssertEqual(userData, _fakeUser)
    }
}

extension TokenHandlerTests {
    class MockTokenStore: TokenStore {
        override init() {
            super.init()
            tokenStoreSuite = "TestTokenStoreSuite"
            UserDefaults().removeSuite(named: tokenStoreSuite)
            userDefaults = UserDefaults(suiteName: tokenStoreSuite)
        }
    }
}
