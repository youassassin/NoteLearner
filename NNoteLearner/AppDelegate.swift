//
//  AppDelegate.swift
//  NewNoteLearner
//
//  Created by Geoffrey Grimaud on 7/17/18.
//  Copyright © 2017 GEI. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // initialize defaults
        let dateKey = "dateKey"
        let lastRead = UserDefaults.standard.object(forKey: dateKey) as? Date
        if lastRead == nil {
            let appDefaults = [
                dateKey : Date()
            ]
            
            // do any other initialization you want to do here - e.g. the starting default values.
            UserDefaults.standard.set(true, forKey: "showNote")
            UserDefaults.standard.set(2.0, forKey: "noteToneDelay")
            UserDefaults.standard.set(2, forKey: "toneRepeats")
            UserDefaults.standard.set(0, forKey: "selectedClef")
            UserDefaults.standard.set(2, forKey: "sharps")
            UserDefaults.standard.set(0.0, forKey: "lowNoteTreble")
            UserDefaults.standard.set(21.0, forKey: "highNoteTreble")
            UserDefaults.standard.set(5.0, forKey: "lowNoteBass")
            UserDefaults.standard.set(21.0, forKey: "highNoteBass")
            // sync the defaults to disk
            UserDefaults.standard.register(defaults: appDefaults)
            UserDefaults.standard.synchronize()
        }
        UserDefaults.standard.set(Date(), forKey: dateKey)
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
    
    
}

