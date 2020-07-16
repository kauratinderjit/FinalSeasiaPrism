//
//  ProfieSegmentVC.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 6/25/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import UIKit

class ProfieSegmentVC: BaseUIViewController {
    
    var currentController = UIViewController()
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var mainView: UIView!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setBackButton()
      self.ProfileSelected()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionCorridorInfo(_ sender: UIButton) {
       
          }
    
    

    @IBAction func actionSegemnt(_ sender: UISegmentedControl) {
        
        if checkInternetConnection(){
        if (sender.selectedSegmentIndex == 0)
        {
            self.ProfileSelected()
        }
        else
        {
            self.PostsSelected()
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
              
              
              func ProfileSelected()
              {
               self.currentController = UIStoryboard.init(name:"Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                 self.activeViewController = self.currentController
              }
              
              func PostsSelected()
              {
          
                 self.currentController = UIStoryboard.init(name:"NewsFeedAndLetter", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileNewsFeedVC") as! ProfileNewsFeedVC
                  self.activeViewController = self.currentController
              }


}
