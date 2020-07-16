//
//  OtherDetailsVC.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 5/29/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import UIKit

class OtherDetailsVC: BaseUIViewController {
    
    var currentController = UIViewController()
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var mainView: UIView!
    var strRole = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
         setBackButton()
        thisThatSelected()
        str_Role = strRole
    }
    

    @IBAction func actionSegmentControl(_ sender: UISegmentedControl) {
        
        if checkInternetConnection(){
        if (sender.selectedSegmentIndex == 0)
        {
            self.thisThatSelected()
        }
        else
        {
            self.CorridorSelected()
        }
            
        }
        else{
                          self.showAlert(Message: Alerts.kNoInternetConnection)
                      }
    }
    //MARK: <-HANDLING OF SELECTED TABS AND CHILD VIEW CONTROLLERS ->
           private var activeViewController: UIViewController?
           {
               didSet
               {
                   removeInactiveViewController(inactiveViewController: oldValue)
                   updateActiveViewController()
               }
           }
           
           private func removeInactiveViewController(inactiveViewController: UIViewController?)
           {
               if let inActiveVC = inactiveViewController
               {
                   // call before removing child view controller's view from hierarchy
                   inActiveVC.willMove(toParent: nil)
                   
                   inActiveVC.view.removeFromSuperview()
                   
                   // call after removing child view controller's view from hierarchy
                   inActiveVC.removeFromParent()
               }
           }
           
           private func updateActiveViewController()
           {
               
               let mapViewController = self.currentController
               mapViewController.willMove(toParent: self)
               
               mapViewController.view.frame.size.width = self.mainView.frame.size.width
               mapViewController.view.frame.size.height = self.mainView.frame.size.height
               // Add to containerview
               self.mainView.addSubview(mapViewController.view)
               self.addChild(mapViewController)
               mapViewController.didMove(toParent: self)
           }
           
           
           func thisThatSelected()
           {
            self.currentController = UIStoryboard.init(name:"Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "ThisThatVC") as! ThisThatVC
                      self.activeViewController = self.currentController
           }
           
           func CorridorSelected()
           {
       
              self.currentController = UIStoryboard.init(name:"Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "CorridorConVC") as! CorridorConVC
               self.activeViewController = self.currentController
           }

}
