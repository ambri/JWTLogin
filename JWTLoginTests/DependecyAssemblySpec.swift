//
// Created by Ati on 2019-05-17.
// Copyright (c) 2019 Ati. All rights reserved.
//

import Nimble
import SwinjectStoryboard
import Quick
import Moya
@testable import JWTLogin

class DependencyAssemblySpec: QuickSpec {
    override func spec() {
        describe("DependencyAssembly") {
            SwinjectStoryboard.apply()
            let sut = SwinjectStoryboard.defaultContainer

            // services
            it("can resolve a TokenStore") {
                let s = sut.resolve(PTokenStore.self)!
                expect(s).to(beAnInstanceOf(TokenStore.self))
            }

            it("can resolve an AuthService") {
                let s = sut.resolve(PAuthService.self)!
                expect(s).to(beAnInstanceOf(AuthService.self))
            }

            it("can resolve a MoyaProvider") {
                let s = sut.resolve(MoyaProvider<MultiTarget>.self)!
                expect(s).to(beAnInstanceOf(MoyaProvider<MultiTarget>.self))
            }
            //end services

            // view models
            it("can resolve a RouterViewModel") {
                let vm = sut.resolve(PRouterViewModel.self)!
                expect(vm).to(beAnInstanceOf(RouterViewModel.self))
            }

            it("can resolve a LoginViewModel") {
                let vm = sut.resolve(PLoginViewModel.self)!
                expect(vm).to(beAnInstanceOf(LoginViewModel.self))
            }
            // end view models

            // view controllers
            it("can resolve a RouterViewController") {
                let vc = SwinjectStoryboard.create(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "RouterViewController") as? RouterViewController
                expect(vc).to(beAnInstanceOf(RouterViewController.self))
                expect(vc?.viewModel).to(beAnInstanceOf(RouterViewModel.self))
            }

            it("can resolve a LoginViewController") {
                let vc = SwinjectStoryboard.create(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                expect(vc).to(beAnInstanceOf(LoginViewController.self))
                expect(vc?.viewModel).to(beAnInstanceOf(LoginViewModel.self))
            }

            it("can resolve a HomeViewController") {
                let vc = SwinjectStoryboard.create(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "HomeViewController")
                expect(vc).to(beAnInstanceOf(HomeViewController.self))
            }
            // end view controllers
        }
    }
}
