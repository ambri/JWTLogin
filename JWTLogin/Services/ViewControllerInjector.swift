//
//  ViewControllerInjector.swift
//  JWTLogin
//
//  Created by Ati on 2019. 05. 11..
//  Copyright © 2019. Ati. All rights reserved.
//

import SwinjectStoryboard

protocol PViewControllerInjector {
    func inject(viewController identifier: String, in storyboard: String) -> UIViewController
}

struct ViewControllerInjector: PViewControllerInjector {
    func inject(viewController identifier: String, in storyboard: String) -> UIViewController {
        let viewController = SwinjectStoryboard.create(
            name: storyboard,
            bundle: nil,
            container: SwinjectStoryboard.defaultContainer
            ).instantiateViewController(withIdentifier: identifier)
        
        return viewController
    }
}
