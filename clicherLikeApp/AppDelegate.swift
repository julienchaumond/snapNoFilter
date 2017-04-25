//
//  AppDelegate.swift
//  clicherLikeApp
//
//  Created by Julien Chaumond on 25/04/2017.
//  Copyright © 2017 Clicher. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.tintColor = Style.keyColor
    
        let sb = UIStoryboard(name: "LaunchScreen", bundle:nil)
        let vc = sb.instantiateInitialViewController()
        
        window?.rootViewController = vc
        window!.makeKeyAndVisible()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
            let homeViewController = HomeViewController()
            let navigationController = UINavigationController(rootViewController: homeViewController)
            
            self.window?.rootViewController = navigationController
        })
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

