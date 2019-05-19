//
//  Main.swift
//  JWTLogin
//
//  Created by Ati on 2019. 05. 11..
//  Copyright © 2019. Ati. All rights reserved.
//

import UIKit
let isRunningTests = NSClassFromString("XCTestCase") != nil
let appDelegateClass: AnyClass? = isRunningTests ? NSClassFromString("JWTLogin.FakeAppDelegate") : AppDelegate.self
_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass!))
