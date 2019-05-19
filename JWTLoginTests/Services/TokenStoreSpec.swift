//
// Created by Ati on 2019-05-16.
// Copyright (c) 2019 Ati. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import JWTLogin

class TokenStoreSpec: QuickSpec {
    override func spec() {
        describe("TokenStore") {
            let sut = TokenStore()

            beforeEach {
                sut.clear()
            }

            it("stores the token") {
                let token = try! JSONDecoder().decode(Token.self, from: FakeJsons.token.rawValue.data(using: .utf8)!)
                expect(sut.save(token)).to(beTrue())
            }

            context("token inquiring") {
                it("return nil if there is no stored token") {
                    let token = sut.get()
                    expect(token).to(beNil())
                }
            }

        }
    }
}
