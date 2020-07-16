//
//  AppDelegate.swift
//  SeasiaNoticeBoard
//
//  Created by Poonam Sharma on 18/5/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import UIKit
import UserNotificationsUI
import PushKit
import Firebase



var DeviceToken : String = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
           FirebaseApp.configure()
       // REGISTER FOR PUSH NOTIFICATIONS
     
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound])  { (granted, error) in
                // Enable or disable features based on authorization.
                if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()}
                }
            }
        } else {
            // REGISTER FOR PUSH NOTIFICATIONS
            let notifTypes:UIUserNotificationType  = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: notifTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            application.applicationIconBadgeNumber = 0

        }
        
        
        
        if UserDefaultExtensionModel.shared.currentUserId != 0 {
            let storyboard = UIStoryboard.init(name: KStoryBoards.kNewsfeedAndLetter, bundle: nil)
                       let vc = storyboard.instantiateViewController(withIdentifier: "NewsLetterAndFeedVC") as? NewsLetterAndFeedVC
                      let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let nav = UINavigationController(rootViewController: vc!)
                      appDelegate.window?.rootViewController = nav
        }
        Thread.sleep(forTimeInterval: 2.0)
        
        
        
        return true
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("DEVICE TOKEN = \(deviceToken)")
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data)}
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        let pasteboard = UIPasteboard.general
        pasteboard.string = token
        UserDefaults.standard.set(token, forKey: "token")
        
    }
    
        
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print(error)
        }
        
        
//    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {

//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
                    print(userInfo)
        
                if application.applicationState == .active
                {
                    if self.window != nil {
                            Notificationview.sharedInstance.createNotificationview(win: self.window!)
                            Notificationview.sharedInstance.showNotificationView(userInfo as NSDictionary)
                    }
        
                }
    }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            
            let dict = (response.notification.request.content.userInfo)
            
            print("dict: ",dict)
            
          
        }
    
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
        {
            completionHandler([.alert, .badge, .sound])
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

   
