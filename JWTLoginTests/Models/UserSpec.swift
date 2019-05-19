//
//  UserTests.swift
//  JWTLoginTests
//
//  Created by Ati on 2019. 05. 04..
//  Copyright © 2019. Ati. All rights reserved.
//

import XCTest
import Quick
import Foundation
import Nimble
@testable import JWTLogin

class UserSpec: QuickSpec {
    override func spec() {
        describe("User") {
            var sut: User!
            
            it("initializes itself from Token") {
                sut = try! JSONDecoder().decode(User.self, from: FakeJsons.user.rawValue.data(using: .utf8)!)
                expect(sut.id).to(equal("50a7da1d-fe07-4c14-8b1b-007737f47763"))
                expect(sut.username).to(equal("jdoe"))
                expect(sut.name).to(equal("John Doe"))
                expect(sut.role).to(equal("editor"))
            }
        }
    }
}
