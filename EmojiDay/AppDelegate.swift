//
//  AppDelegate.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/16/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - UIApplicationDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = MainViewController.sharedInstance
        window?.makeKeyAndVisible()
        return true
    }
}
