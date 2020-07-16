//
//  NotificationView.swift
//  Ala
//
//  Created by Sahil Arora on 27/01/17.
//  Copyright © 2017 Sahil Arora. All rights reserved.
//

import Foundation

import AVFoundation

/**
 Notificationview class is used to create , display notifications when the app is in foreground.
 */

class Notificationview: NSObject {
    
    
    static let sharedInstance = Notificationview()
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    //let win:UIWindow = UIApplication.shared.keyWindow!
    //var win :UIWindow = ((UIApplication.shared.delegate?.window)!)!
    
    var Win = UIWindow()
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    let view_Notification = UIView.init(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: 80))
    
    let lbl_Heading : UILabel = UILabel.init(frame: CGRect(x: 54, y: 14, width: UIScreen.main.bounds.width - 100, height: 20))
    
    let lbl_Notification : UILabel = UILabel.init(frame: CGRect(x: 54, y: 28, width: UIScreen.main.bounds.width - 100, height: 40))
    
    let img_Logo : UIImageView = UIImageView.init(frame: CGRect(x: 8, y: 20, width: 40, height: 40))
    
    let btn_Notification : UIButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
    
    var dic_Info : NSDictionary = NSDictionary()
    
}


extension Notificationview {
    
    
    /**
     createNotificationview is used to create the notification view because we need a custom view to show notifications when the app is in foreground.
     */
    
    func createNotificationview(win:UIWindow) {
        
        Win = win
        img_Logo.image = UIImage.init(named: "notification")
        img_Logo.contentMode = .scaleAspectFill
        
        btn_Notification.addTarget(self, action: #selector(Notificationview.notificationClicker(_:)), for: .touchUpInside)
        
        
        view_Notification.addSubview(lbl_Notification)
        view_Notification.addSubview(btn_Notification)
        view_Notification.addSubview(img_Logo)
        view_Notification.addSubview(lbl_Heading)
        
        lbl_Notification.textColor = UIColor.darkGray
        lbl_Notification.font = UIFont.systemFont(ofSize: 12.0)
        
        view_Notification.layer.masksToBounds = false
        view_Notification.layer.borderColor = UIColor.lightGray.cgColor
        //view_Notification.layer.borderWidth = 1.0
        view_Notification.layer.cornerRadius = 10.0
        
        view_Notification.layer.shadowOffset = CGSize(width: 0, height: 0);
        view_Notification.layer.shadowRadius = 2;
        view_Notification.layer.shadowOpacity = 0.5;
        
        
        lbl_Notification.numberOfLines=0;
        
        lbl_Heading.textColor = UIColor.black
        lbl_Heading.font = UIFont.systemFont(ofSize: 14.0)
        lbl_Heading.text = "Seasia Prism"
        
        
        view_Notification.backgroundColor = UIColor.white
        
        appDelegate?.window?.addSubview(view_Notification)
        
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(Notificationview.respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.up
        view_Notification.addGestureRecognizer(swipeDown)
        view_Notification.isHidden=true
        
    }
    
    /**
     respondToSwipeGesture is used to detect wether the user swiped up or down the notification view.
     
     :param:  gesture UIGestureRecognizer object.
     */
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                hideNotificationView()
            default:
                break
            }
        }
    }
    
    /**
     showNotificationView is used to show the notification whenever received when the app is in foreground.
     
     :param:  info contains the detail which is required to show on notification view.
     */
    
    func showNotificationView(_ info:NSDictionary) {
        
        //print(Win)
        Win.windowLevel = UIWindow.Level.statusBar + 1
        dic_Info = info
        let _ :UIWindow = UIApplication.shared.keyWindow!

   
        if (dic_Info.value(forKey: "jsonResponse") as? String) != nil {
            
            
          let details = dic_Info.value(forKey: "aps") as! NSDictionary
            lbl_Notification.text =  details.value(forKey: "alert") as? String
            
         
            
        }
            
        else if dic_Info.value(forKey: "aps") != nil {
            let details = dic_Info.value(forKey: "aps") as! NSDictionary
            lbl_Notification.text =  details.value(forKey: "alert") as? String
        }
            
        else {
            

         lbl_Notification.text = "A new story is posted on the wall."
        }
        
        print(lbl_Notification.text!)
        UIApplication.shared.isStatusBarHidden = false
        btn_Notification.isUserInteractionEnabled = true
        
        UIView.transition(with: view_Notification, duration: 0.8, options: UIView.AnimationOptions(), animations: {
            
            self.view_Notification.frame = CGRect(x: 10, y:35, width: UIScreen.main.bounds.width - 20, height: 80)
            
        }, completion: nil)
        
        AudioServicesPlaySystemSound(1315);
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        view_Notification.isHidden = false;
        self.btn_Notification.isUserInteractionEnabled = true;
        
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(Notificationview.hideNotificationView), object: nil)
        
        self.perform(#selector(Notificationview.hideNotificationView), with: nil, afterDelay: 3.0)
        
        
        
    }
    
    /**
     hideNotificationView is used to hide the notification when the user swipe the notification view up or it will automatically hide after 3 second.
     */
    
    @objc func hideNotificationView () {
        
        UIView.transition(with: view_Notification, duration: 0.5, options: UIView.AnimationOptions(), animations: {
            
            self.view_Notification.frame = CGRect(x: 10, y: -100, width: UIScreen.main.bounds.width - 20, height: 80)
            
            
        }, completion: { (error) in
            self.Win.windowLevel = UIWindow.Level.normal
        })
        
    }
    
    /**
     This method is used to get the Shared Product ID from the payload.
     
     :param:  string The string from which further we filter product id.
     
     :param:  userInfo This object contains the notification payload received.
     
     :return: String filtered product id string
     */
    
    func returnFilteredString(_ string:String) -> String {
        
        var arrayTemp : NSArray = NSArray()
        string.enumerateLines { (line, stop) in
            
            arrayTemp = line.components(separatedBy: ",") as NSArray
        }
        
        let str_product = arrayTemp.object(at: 0)
        
        
        let str_temp = (str_product as AnyObject).replacingOccurrences(of: "{", with: "") as NSString
        
        
        let temp1 = str_temp.substring(to: str_temp.length - 1) as NSString
        
        
        let finalTemp = temp1.substring(from: 11)
        
        
        return finalTemp
    }
    
    /**
     This method is called whenever user clicks the notification view.
     
     :param:  sender In this case it is a UIButton.
     
     :return: String filtered product id string
     */
    
    @objc func notificationClicker (_ sender: AnyObject) {
        
        btn_Notification.isUserInteractionEnabled = false
        //hideNotificationView()
        
        
        }
    
    


    }
    

