//
//  LoginVC.swift
//  SeasiaNoticeBoard
//
//  Created by Poonam Sharma on 18/5/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import UIKit

class LoginVC: BaseUIViewController {

    @IBOutlet weak var txtFieldEmail: UITextField!
    var viewModel : AuthenticationViewModel?
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var iconLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        iconLogo.setImageColor(color: UIColor.init(red: 24/255, green: 174/255, blue: 122/255, alpha: 1))
        //ddTopBorder(with: UIColor.lightGray, view: viewBG)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        self.viewModel = AuthenticationViewModel.init(delegate: self)
        self.viewModel?.attachView(view: self)
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.shadowImage = UIColor.placeholderText.as1ptImage()
        } else {
            self.navigationController?.navigationBar.shadowImage = UIColor.lightGray.as1ptImage()
        }

        if strlogot == "logout" {
            strlogot = ""
            self.showAlert(alert: "User logged out successfully")
        }
        

    }
    //Calls this function when the tap is recognized.
    @objc override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func isValidEmail(testEmail:String, domain:String) -> Bool {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[\(domain)|yopmail.com]+\\.[Com|com|COM]{3,\(domain.count)}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testEmail)
        if result == false{
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[\(domain)|seasia]+\\.[in|IN]{2,\(domain.count)}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: testEmail)
              return result
        }
        return result
    }

    @IBAction func btnSubmit(_ sender: Any) {
        
        if txtFieldEmail.text != "" {
            
            if txtFieldEmail.text!.contains("yopmail.com")  || txtFieldEmail.text!.contains("seasia.in") {
        if isValidEmail(testEmail: txtFieldEmail.text ?? "", domain: "com") {
            
            if checkInternetConnection()
                 {
                     self.viewModel?.logInUser(email: txtFieldEmail.text)
                 }
              else
              {
               self.showAlert(Message: Alerts.kNoInternetConnection)
              }
            
        }
        else{
            self.showAlert(Message: "Please enter valid email")
            txtFieldEmail.text = ""
        }
        }
            else{
                       self.showAlert(Message: "Please enter valid email")
                       txtFieldEmail.text = ""
                   }
        
        }
        else{
         self.showAlert(Message: "Email field can't be empty")
    }
}
}

extension LoginVC: LogInDelegate {
    func otpVerification(data: VerifyOTP) {
        
    }
    
    
    
    func loginDidSucced(data: LoginData) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CheckOTPVC") as! CheckOTPVC
        newViewController.ResultData = data
        newViewController.email = txtFieldEmail.text ?? ""
        newViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func loginDidFalied() {
        
    }
    
    func DidFailedRole() {
        
    }
    
}

extension LoginVC:  ViewDelegate
{
    
    func showAlert(alert: String)
    {
        self.showAlert(Message: alert)
    }
    
    func showLoader()
    {
        self.ShowLoader()
    }
    
    func hideLoader()
    {
        self.HideLoader()
    }
    
}

extension LoginVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
