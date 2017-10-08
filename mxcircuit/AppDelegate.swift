//
//  AppDelegate.swift
//  mxcircuit
//
//  Created by Mario alcazar on 20/8/17.
//  Copyright © 2017 Mario alcazar. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        
        do {
            Network.reachability = try Reachability(hostname: "www.google.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("AQUI DEVICE TOKEN: \(deviceTokenString)")
        setToken(deviceTokenString)
        
        checkToken(deviceTokenString)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        
        let state : UIApplicationState = application.applicationState
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                
                let title: String = (alert["title"] as? String)!
                let body: String = (alert["body"] as? String)!
                let idCircuit : String = (alert["circuit_id"] as? String)!
                
                setIdCircuitNotification(idCircuit)
                
                application.applicationIconBadgeNumber = 0
                if idCircuit != "55"{
                    
                    switch state {
                    case .active:
                    
                        self.window?.rootViewController?.present(showAlert(title, messageData: body), animated: true, completion: {
                            var rootViewController = self.window!.rootViewController as! UINavigationController
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            var profileVC = mainStoryboard.instantiateViewController(withIdentifier: "ProfileCircuitTableViewController") as! ProfileCircuitTableViewController
                            rootViewController.pushViewController(profileVC, animated: true)
                        })
                    default:
                        var rootViewController = self.window!.rootViewController as! UINavigationController
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        var profileVC = mainStoryboard.instantiateViewController(withIdentifier: "ProfileCircuitTableViewController") as! ProfileCircuitTableViewController
                        rootViewController.pushViewController(profileVC, animated: true)
                    }
                    
                }
                
            }
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        
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
        application.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


