//
//  AppDelegate.swift
//  Watch_1373
//
//  Created by Robert Haworth on 2/23/15.
//  Copyright (c) 2015 Robert Haworth. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        configureApperances()

        NSUserDefaults.standardUserDefaults().registerDefaults(["enabled_onboarding": true, "network_logging": false, "watch_name": "Watch-0000"])

        // Select root storyboard based on Onboarding flag in Settings app
        let startWithOnboarding = NSUserDefaults.standardUserDefaults().boolForKey("enabled_onboarding")
        let storyboard = UIStoryboard(name: startWithOnboarding ? "Onboarding" : "RootTabBar", bundle: nil)
        let rootViewController = storyboard.instantiateInitialViewController() as! UIViewController
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

//        setupBluetoothLink()

        /*
        let exosite = BackendSession.sharedInstance()
        let emailAddress = "wlafrance+11@lsr.com"
        let password = "Asdf1234"
        exosite.createAccount(emailAddress: emailAddress, password: password) { result in
            result.onSuccess {
                LSRLog(.Exosite, .Info, "CreateUser succeeded! \($0)")
                exosite.authentication = BackendSessionAuthentication(username: emailAddress, password: password)
            }.onFailure {
                LSRLog(.Exosite, .Error, "CreateUser failed! \($0)")
            }
        }
        */

        return true
    }

//    func setupBluetoothLink() {
//        let watchLink = BluetoothWatchLink.sharedInstance()
//        LSRLog(.Initialization, .Info, "BluetoothWatchLink setup: \(watchLink)")
//
//        watchLink.registerMessageHandler(WatchFirmwareVersionMsg_t.self) {
//            LSRLog(.BluetoothWatchLink, .Info, "Watch reported firmware version: \($0)"); return
//        }
//
//        watchLink.registerMessageHandler(LSR_FitnessData_t.self) {
//            LSRLog(.BluetoothWatchLink, .Info, "Fitness data (non-dashboard): \($0)"); return
//        }
//    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func configureApperances() {
        let font = UIFont.withFace(.GothamBook, size: 14.0)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName : font,
            NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)

        let largerFont = UIFont.withFace(.GothamMedium, size: 18.0)
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : largerFont,
            NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = JardenColor.teal
        UITabBar.appearance().tintColor = JardenColor.teal
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        println("handleOpenURL: \(url)")
        
        if url.fileURL
        {
            if url.pathExtension == "olw"
            {
                println("going to handle an incoming firmware file")
                let firmwareFileName = url.lastPathComponent?.stringByDeletingPathExtension
                let firmwareFileData = NSData(contentsOfURL: url)
                if firmwareFileData == nil
                {
                    return true;
                }
                
                addFirmwareFile(firmwareFileData!, firmwareFileName!)
                println("current firmware: \(allAvailableFirmwareFileNames())")
            }
        }
        return true
    }
}
