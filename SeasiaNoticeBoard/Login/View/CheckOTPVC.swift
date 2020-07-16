//
//  CheckOTPVC.swift
//  Fleet Management
//
//  Created by Mohit Sharma on 2/19/20.
//  Copyright © 2020 Seasia Infotech. All rights reserved.
//

import UIKit
import SVPinView


class CheckOTPVC: BaseUIViewController
{
    
    //MARK:- OUTLETS -->
    @IBOutlet var lblTitleDESC: UILabel!
    @IBOutlet var btnResendOTP: UIButton!
    @IBOutlet var lblOTP: UILabel!
    @IBOutlet var myPinView: SVPinView!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var lblTimerDesc: UILabel!
    var  ResultData : LoginData?
    //MARK:- VARIABLES -->
   // var viewModel:LoginWithPhone_ViewModel?
    var otp = ""
    var email = ""
    var countryCode = ""
    var push_approach = ""
    var myTimer = Timer()
    var count  = 0
    var count_reverse  = 60
    var viewModel : AuthenticationViewModel?
    var id = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.set_controller_UI()
        self.hideKeyboardWhenTappedAround()
        myPinView.style = .box
        self.viewModel = AuthenticationViewModel.init(delegate: self)
        self.viewModel?.attachView(view: self)
        id = ResultData?.resultData ?? 0

        myPinView.didFinishCallback = { pin in
            if self.checkInternetConnection(){
            print("The pin entered is \(pin)")
            self.otp = pin
            self.hideKeyboard()
            self.stop_timer()
            self.viewModel?.otpVerification(Otp: pin, OtpId: "\(self.id)")}
            else{
                self.showAlert(Message: Alerts.kNoInternetConnection)
            }
    
        }
        
        myPinView.didChangeCallback = { pin in
        }
        hideNavigationBackButton()
        BackButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.stop_timer()
    }
    
    
    //MARK:- BUTTON ACTIONS -->
    @IBAction func ACTION_RESEND_OTP(_ sender: Any)
    {
        self.myPinView.clearPin()
        self.resend_OTP()
    }
    
    @IBAction func ACTION_MOVEBACK(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    @IBAction func ACTION_PRCEED(_ sender: Any)
    {
        self.hideKeyboard()
        self.stop_timer()
//api
        
    }
    
    //MARK:- FUNCTION RESEND OTP -->
    func resend_OTP()
    {
        
        //api
            
            if checkInternetConnection()
                 {
                     self.viewModel?.logInUser(email: email)
                 }
              else
              {
               self.showAlert(Message: Alerts.kNoInternetConnection)
              }
    
    }
    
    
    
    //MARK:- UI SETUP -->
    func set_controller_UI()
    {
       // self.viewModel = LoginWithPhone_ViewModel.init(view: self)
       
        self.lblOTP.text = "Please enter the code that has been sent to you at \(email )"
       
   
    }
    
    
    @objc func startTimer()
    {
        self.count = self.count+1
        self.count_reverse = self.count_reverse-1
        self.lblTimer.text = "\(self.formatSecondsToString(TimeInterval(self.count_reverse)))"
        if (self.count >= 60)
        {
            self.myTimer.invalidate()
            self.stop_timer()
        }
        
    }
    
    func formatSecondsToString(_ seconds: TimeInterval) -> String
    {
        if seconds.isNaN
        {
            return "00:00"
        }
        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    func Handle_Resend_OTP_Start_timer()
    {
        self.lblTimer.text = "00:00"
        self.btnResendOTP.isHidden = true
        self.lblTimer.isHidden = false
        self.lblTimerDesc.isHidden = false
    }
    func stop_timer()
    {
        self.lblTimer.text = "00:00"
        self.btnResendOTP.isHidden = false
        self.lblTimer.isHidden = true
        self.lblTimerDesc.isHidden = true
    }
    
}

extension CheckOTPVC: LogInDelegate {
    func otpVerification(data: VerifyOTP) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                 let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                 newViewController.email = email
                    newViewController.viewprofile = ""
       // let nav = UINavigationController(rootViewController: newViewController)
                 newViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(newViewController, animated: true)
      
    }
    
    func loginDidSucced(data: LoginData)
    {
    
        id = data.resultData ?? 0
        self.showAlert(alert: "OTP has been sent to the given email id")
        self.Handle_Resend_OTP_Start_timer()
        self.myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.myTimer, forMode: RunLoop.Mode.common)
       
    }
    
    func loginDidFalied() {
        myPinView.clearPin()
    }
    
    func DidFailedRole() {
        
    }
    
}

extension CheckOTPVC :  ViewDelegate
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
