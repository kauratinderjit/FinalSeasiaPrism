//
//  AuthenticationViewModel.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 5/20/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import Foundation


protocol LogInDelegate:class {
    func loginDidSucced(data: LoginData)
    func loginDidFalied()
    func DidFailedRole()
    func otpVerification(data: VerifyOTP)
    
}

class AuthenticationViewModel {

    //LogIn delegate
   private weak var delegatelogin : LogInDelegate?
    
    //LogIn View
   private weak var logInView : ViewDelegate?
 
    
    //Initialize the Presenter class
    init(delegate:LogInDelegate) {
        delegatelogin = delegate
    }
    
    //Attaching login view
    func attachView(view: ViewDelegate) {
        logInView = view
    }
    
    //Detaching login view
//    func detachView() {
//        logInView = nil
//    }

    
    //MARK:- User Logged In Through Email/Phone number and password and get user token
    func logInUser(email: String?) {
        
        do {
            self.logInView?.showLoader()

            //Login User Using Email And Password and get token
            LoginApi.sharedmanagerAuth.LogInApi(url: "api/User/EmailVerificationForSignUp?email=\(String(describing: email!))", parameter: nil, completionResponse: { (response) in

                print(response)
                self.logInView?.hideLoader()
                
                if response.statusCode == KStatusCode.kStatusCode200{
                    if response.resultData == 0 {
                      self.logInView?.showAlert(alert: "Something went wrong! Please try again.")
                    }
                    else {
                        self.delegatelogin?.loginDidSucced(data: response)}
                }
                else if response.statusCode == KStatusCode.kStatusCode400
                {
                    self.logInView?.showAlert(alert: response.message!)
                }

            }, completionnilResponse: { (String) in
                self.logInView?.hideLoader()
                self.logInView?.showAlert(alert: "Network is lost")
            }) { (error) in
                self.logInView?.hideLoader()
                self.logInView?.showAlert(alert: "Something went wrong! Please try again.")
            }
    }
        catch let error
        {
            switch  error {
            case ValidationError.emptyPhoneNumber:
                   self.logInView?.showAlert(alert: Alerts.kEmptyPhoneNumber)
            case ValidationError.minCharactersPhoneNumber:
                self.logInView?.showAlert(alert: Alerts.kMinPhoneNumberCharacter)
            case ValidationError.emptyPassword:
                self.logInView?.showAlert(alert: k_EmptyPassword)
            case ValidationError.passwordlengthshouldbe8to16long:
              self.logInView?.showAlert(alert: k_MinPasswordLength)
            default:
                  CommonFunctions.sharedmanagerCommon.println(object:k_DefaultCase)
                break
            }
        }
    }
    
    
    func otpVerification(Otp: String,OtpId : String) {
        
        do {
            self.logInView?.showLoader()
            
            let param = [  "Otp" : Otp,
                                "OtpId" : OtpId
                            ] as [String : Any]

            //Login User Using Email And Password and get token
            LoginApi.sharedmanagerAuth.verifyOTP(url: "api/User/VerifyEmail", parameter: param, completionResponse: { (response) in

                print(response)
                self.logInView?.hideLoader()
                
                if response.statusCode == KStatusCode.kStatusCode200{
                   
                    if response.resultData == nil {
                        self.delegatelogin?.otpVerification(data: response)}
                    else{
                        
                        AppDefaults.shared.userName = (response.resultData?.FirstName ?? "") + " " + (response.resultData?.LastName ?? "")
                                                 AppDefaults.shared.userFirstName = response.resultData?.FirstName ?? ""
                                                 AppDefaults.shared.userLastName = response.resultData?.LastName ?? ""
                                                 //AppDefaults.shared.userJWT_Token = self.userData.body?.sessionToken ?? ""
                                                 AppDefaults.shared.userEmail = response.resultData?.Email ?? ""
                                              AppDefaults.shared.userPhoneNumber =  response.resultData?.PhoneNo ?? ""
                                              UserDefaultExtensionModel.shared.currentUserId = response.resultData?.UserId ?? 0
                                                 AppDefaults.shared.userImage = response.resultData?.ImageUrl ?? ""
                                                AppDefaults.shared.bio = response.resultData?.Bio ?? ""
                                   
                        let storyboard = UIStoryboard.init(name: KStoryBoards.kNewsfeedAndLetter, bundle: nil)
                                   let vc = storyboard.instantiateViewController(withIdentifier: "NewsLetterAndFeedVC") as? NewsLetterAndFeedVC
                                  let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let nav = UINavigationController(rootViewController: vc!)
                                  appDelegate.window?.rootViewController = nav
                                   
                    }
                    self.logInView?.showAlert(alert: response.message!)

                }
                else if response.statusCode == KStatusCode.kStatusCode400
                {
                    self.logInView?.showAlert(alert: response.message!)
                    self.delegatelogin?.loginDidFalied()
                }

            }, completionnilResponse: { (String) in
                self.logInView?.hideLoader()
                self.logInView?.showAlert(alert: String)
            }) { (error) in
                self.logInView?.hideLoader()
                self.logInView?.showAlert(alert: error.debugDescription)
            }
    }
        catch let error
        {
            switch  error {
            case ValidationError.emptyPhoneNumber:
                   self.logInView?.showAlert(alert: Alerts.kEmptyPhoneNumber)
            case ValidationError.minCharactersPhoneNumber:
                self.logInView?.showAlert(alert: Alerts.kMinPhoneNumberCharacter)
            case ValidationError.emptyPassword:
                self.logInView?.showAlert(alert: k_EmptyPassword)
            case ValidationError.passwordlengthshouldbe8to16long:
              self.logInView?.showAlert(alert: k_MinPasswordLength)
            default:
                  CommonFunctions.sharedmanagerCommon.println(object:k_DefaultCase)
                break
            }
        }
    }
   
}
