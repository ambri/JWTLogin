//
//  RouterViewControllerSpec.swift
//  JWTLoginTests
//
//  Created by Ati on 2019. 05. 10..
//  Copyright © 2019. Ati. All rights reserved.
//


@testable import JWTLogin
import XCTest
import RxSwift
import RxCocoa
import SwinjectStoryboard
import Quick
import Nimble

class RouterViewControllerSpec: QuickSpec {
    override func spec() {
        describe("RouterViewController") {
            var sut: RouterViewController!
            var viewModel: MockRouterViewModel!

            beforeEach {
                self.registerDependencies()
                sut = SwinjectStoryboard.create(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "RouterViewController") as? RouterViewController

                guard sut != nil,
                      let vm = sut.viewModel as? MockRouterViewModel else {
                    preconditionFailure()
                }

                viewModel = vm
            }
            
            afterEach {
                sut = nil
                viewModel = nil
            }

            context("when the view has loaded") {
                beforeEach {
                    sut.loadViewIfNeeded()
                }
                
                it("shows a progress indicator") {
                    expect(sut.activityIndicator.isHidden).to(beFalse())
                }
                
                it("requests token refreshing form the viewmodel") {
                    expect(viewModel.refreshTokenHasCalled).to(beTrue())
                }
            }

            context("when the view has appeared and the token refreshing has finished") {
                beforeEach {
                    presentAsInitialViewController(sut)
                }

                it("shows the login view if it was failed") {
                    viewModel.expectRefreshResult(false)
                    triggerViewDidAppear(sut)
                    expect(sut.presentedViewController).to(beAnInstanceOf(LoginViewController.self))
                }
                
                it("shows the home view if it was success") {
                    viewModel.expectRefreshResult(true)
                    triggerViewDidAppear(sut)
                    expect(sut.presentedViewController).to(beAnInstanceOf(HomeViewController.self))
                }
            }
        }
    }
}

extension RouterViewControllerSpec {
    func registerDependencies() {
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(RouterViewController.self) { r, c in
            c.viewModel = r.resolve(PRouterViewModel.self)
        }

        SwinjectStoryboard.defaultContainer.register(PRouterViewModel.self) { resolver in
            return MockRouterViewModel()
        }
    }

    class MockRouterViewModel: PRouterViewModel {
        var refreshResult: Bool = false
        var refreshTokenHasCalled = false
        
        func expectRefreshResult(_ result: Bool) {
            refreshResult = result
        }

        func refreshToken() -> Single<Bool> {
            refreshTokenHasCalled = true
            return Single.just(refreshResult)
        }
    }
}
