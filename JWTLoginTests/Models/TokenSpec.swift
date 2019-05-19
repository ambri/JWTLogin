//
//  TokenSpec.swift
//  JWTLoginTests
//
//  Created by Ati on 2019. 05. 04..
//  Copyright © 2019. Ati. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import JWTLogin

class TokenSpec: QuickSpec {
    override func spec() {
        describe("Token") {
            var sut: Token!
            
            it("initializes itself from Token") {
                sut = try! JSONDecoder().decode(Token.self, from: FakeJsons.token.rawValue.data(using: .utf8)!)
            expect(sut.accessToken).to(equal("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZHA6dXNlcl9pZCI6IjUwYTdkYTFkLWZlMDctNGMxNC04YjFiLTAwNzczN2Y0Nzc2MyIsImlkcDp1c2VyX25hbWUiOiJqZG9lIiwiaWRwOmZ1bGxuYW1lIjoiSm9obiBEb2UiLCJyb2xlIjoiZWRpdG9yIiwiZXhwIjoxNTU2NDc2MjU1fQ.iqFmotBtfAYLplfpLVh_kPgvOIPyV7UMm-NZA06XA5I"))
                expect(sut.expiresIn).to(equal(119))
                expect(sut.refreshToken).to(equal("NTBhN2RhMWQtZmUwNy00YzE0LThiMWItMDA3NzM3ZjQ3NzYzIyNkNmQ5OTViZS1jY2IxLTQ0MGUtODM4NS1lOTkwMTEwMzBhYzA="))
                expect(sut.tokenType).to(equal("bearer"))
            }
        }
    }
}
