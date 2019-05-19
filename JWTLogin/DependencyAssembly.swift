//
//  DependencyAssembly.swift
//  JWTLogin
//
//  Created by Ati on 2019. 05. 10..
//  Copyright © 2019. Ati. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import Moya

extension SwinjectStoryboard {
    class func registerStoryboards() {
        defaultContainer.storyboardInitCompleted(RouterViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(PRouterViewModel.self)
        }

        defaultContainer.storyboardInitCompleted(LoginViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(PLoginViewModel.self)
        }

        defaultContainer.storyboardInitCompleted(HomeViewController.self) { resolver, controller in

        }
    }
    
    class func registerViewModels() {
        defaultContainer.register(PRouterViewModel.self) { resolver in
            return RouterViewModel(
                authService: resolver.resolve(PAuthService.self)!
            )
        }

        defaultContainer.register(PLoginViewModel.self) { resolver in
            return LoginViewModel(authService: resolver.resolve(PAuthService.self)!)
        }
    }
    
    class func registerServices() {
        defaultContainer.register(PTokenStore.self) { _ in
            return TokenStore()
        }.inObjectScope(.container)

        defaultContainer.register(MoyaProvider<MultiTarget>.self) { _ in
            return MoyaProvider<MultiTarget>()
        }.inObjectScope(.container)

        defaultContainer.register(PAuthService.self) { resolver in
            return AuthService(
                    tokenStore: resolver.resolve(PTokenStore.self)!,
                    api: resolver.resolve(MoyaProvider<MultiTarget>.self)!)
        }.inObjectScope(.container)
    }
    
    class func apply() {
        registerStoryboards()
        registerViewModels()
        registerServices()
    }
}
