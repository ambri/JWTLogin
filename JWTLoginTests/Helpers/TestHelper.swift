//
//  TestHelper.swift
//  JWTLoginTests
//
//  Created by Ati on 2019. 05. 15..
//  Copyright © 2019. Ati. All rights reserved.
//
import UIKit

internal func presentAsInitialViewController(_ viewController: UIViewController) {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.makeKeyAndVisible()
    window.rootViewController = viewController
}

internal func triggerViewDidAppear(_ viewController: UIViewController) {
    viewController.loadViewIfNeeded()
    viewController.beginAppearanceTransition(true, animated: true)
    viewController.endAppearanceTransition()
}

extension UITextField {
    func sendEditingChanged(withText value: String) {
        text = value
        sendActions(for: .editingChanged)
    }
}
