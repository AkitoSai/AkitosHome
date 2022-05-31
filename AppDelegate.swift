//
//  AppDelegate.swift
//  Daniel
//
//  Created by 蔡 易達 on 2022/5/31.
//  Copyright © 2022年 蔡 易達. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // 建立一個 UIWindow
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // 設置底色
        self.window!.backgroundColor = UIColor.white

        // 設置根視圖控制器
        let navigationController = UINavigationController(rootViewController: MainViewController())
        // 隱藏導覽列標題
        navigationController.navigationBar.isHidden = true
        
        // 禁用導覽列側滑動返回翻頁功能(因為影響遊戲體驗)
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        
        self.window!.rootViewController = navigationController

        // 將 UIWindow 設置為可見的
        self.window!.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationMask
    }
    
    //綁定銀幕方向
    var orientationMask: UIInterfaceOrientationMask = .portrait {
        didSet {
            
            //强制設置銀幕為豎
            UIDevice.current.setValue(NSNumber(value: UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
            
            // 更新
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

