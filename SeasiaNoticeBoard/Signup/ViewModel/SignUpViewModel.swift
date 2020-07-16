//
//  SignUpPresenter.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 6/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

protocol SignUpDelegate:class {
    func signUpSuccess(message: String)
    func GetUserDetailSuccess(data: GetUserDetailByPhoneEmail )
    func DidFailedRoleMenu()
}

class SignUpViewModel{
    weak var delegate:SignUpDelegate?
    weak var signUpView: ViewDelegate?
    init(delegate:SignUpDelegate){
        self.delegate = delegate
    }
    //Attaching view
    func attachView(view: ViewDelegate) {
        signUpView = view
    }
    //Detaching view
    func detachView() {
        signUpView = nil
    }
    

   
    //MARK:- SignUp of User
    func signUpUser(firstName: String?,lastName: String?, email: String?,phoneNo:String?,imgUrl: URL? ,gender: String?,dob: String? ,userId:Int?, Bio: String?)
    {
        //MARk:-Check Validations
        if(firstName!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.signUpView?.showAlert(alert: Alerts.kEmptyFirstName)
        }
        else if(lastName!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.signUpView?.showAlert(alert: Alerts.kEmptyLastName)
        }
        else if(email!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.signUpView?.showAlert(alert: Alerts.kEmptyEmail)
        }
            
        else if(phoneNo!.trimmingCharacters(in: .whitespaces).isEmpty)
                   {
                       self.signUpView?.showAlert(alert: Alerts.kEmptyPhoneNumber)
                   }
        else if (!(email?.isValidEmail())!){
            self.signUpView?.showAlert(alert: Alerts.kInvalidEmail)
        }
            
            else if gender!.trimmingCharacters(in: .whitespaces).isEmpty
            {
                self.signUpView?.showAlert(alert: Alerts.kEmptyGender)
            }
            else if(dob!.trimmingCharacters(in: .whitespaces).isEmpty)
            {
                self.signUpView?.showAlert(alert: Alerts.kEmptyDOB)
            }
            
            
            
        else
        {
            //MARK:- Post SignUp Api
            guard let firstname = firstName else {return}
            guard let lastname = lastName else {return}
            guard let phoneNumber = phoneNo else {return}
            guard let email = email else {return}
             guard let gender = gender else {return}
             guard let dob = dob else {return}
            let paramDict = [KApiParameters.SignUpApiPerameters.kUserId:userId ?? 0,KApiParameters.SignUpApiPerameters.kFirstName:firstname,KApiParameters.SignUpApiPerameters.kLastName:lastname,KApiParameters.SignUpApiPerameters.kPhoneNumber:phoneNumber,KApiParameters.SignUpApiPerameters.kEmail:email,KApiParameters.SignUpApiPerameters.kImageUrl: imgUrl ?? "",KApiParameters.SignUpApiPerameters.kDOB:dob, KApiParameters.SignUpApiPerameters.kGender:gender,
                             "Bio" : Bio ?? ""] as [String : Any]
            
            var url = ""
            if userId != 0 {
                url = "api/User/UpdateUser"
            }
            else {
                url = ApiEndpoints.kSignUpApi
            }

            self.signUpView?.showLoader()
            SignUpApi.sharedInstance.multipartApi(postDict: paramDict as [String : Any], url: url, completionResponse: { (response) in
                print(response)
                
                self.signUpResponseJson(data: response, completionResponse: { (responseModel) in
               
                    self.signUpView?.hideLoader()
                    switch responseModel.statusCode {
                    case KStatusCode.kStatusCode200:
                        
                        
                       
                        
                        AppDefaults.shared.userName = (responseModel.resultData?.FirstName ?? "") + " " + (responseModel.resultData?.LastName ?? "")
                                                                       AppDefaults.shared.userFirstName = responseModel.resultData?.FirstName ?? ""
                                                                       AppDefaults.shared.userLastName = responseModel.resultData?.LastName ?? ""
                                                                       //AppDefaults.shared.userJWT_Token = self.userData.body?.sessionToken ?? ""
                                                                       AppDefaults.shared.userEmail = responseModel.resultData?.Email ?? ""
                                                                    AppDefaults.shared.userPhoneNumber =  responseModel.resultData?.PhoneNo ?? ""
                                                                    UserDefaultExtensionModel.shared.currentUserId = responseModel.resultData?.UserId ?? 0
                                                                       AppDefaults.shared.userImage = responseModel.resultData?.ImageUrl ?? ""
                                                             AppDefaults.shared.bio = responseModel.resultData?.Bio ?? ""
                        guard let msg = responseModel.message else {
                                                   return
                                               }
                     

                        self.delegate?.signUpSuccess(message: msg)

                        
                    case KStatusCode.kStatusCode202:
                        
                        
                        AppDefaults.shared.userName = (responseModel.resultData?.FirstName ?? "") + " " + (responseModel.resultData?.LastName ?? "")
                                                AppDefaults.shared.userFirstName = responseModel.resultData?.FirstName ?? ""
                                                AppDefaults.shared.userLastName = responseModel.resultData?.LastName ?? ""
                                                //AppDefaults.shared.userJWT_Token = self.userData.body?.sessionToken ?? ""
                                                AppDefaults.shared.userEmail = responseModel.resultData?.Email ?? ""
                                             AppDefaults.shared.userPhoneNumber =  responseModel.resultData?.PhoneNo ?? ""
                                             UserDefaultExtensionModel.shared.currentUserId = responseModel.resultData?.UserId ?? 0
                                                AppDefaults.shared.userImage = responseModel.resultData?.ImageUrl ?? ""
                          AppDefaults.shared.bio = responseModel.resultData?.Bio ?? ""
                        guard let msg = responseModel.message else {
                                                   return
                                               }
                       self.delegate?.signUpSuccess(message:msg)
                       
                        
                    case KStatusCode.kStatusCode400:
                        if let msg = responseModel.message{
                            self.signUpView?.showAlert(alert: msg)
                        }
                        //It is came when i updated the hod 
                    case KStatusCode.kStatusCode408:
                        guard let msg = responseModel.message else {return}
                        self.delegate?.signUpSuccess(message:msg)
                        
                    case 0 :
                        guard let msg = responseModel.message else {
                                                return
                                            }
                                            
                                            AppDefaults.shared.userName = (responseModel.resultData?.FirstName ?? "") + " " + (responseModel.resultData?.LastName ?? "")
                                                                    AppDefaults.shared.userFirstName = responseModel.resultData?.FirstName ?? ""
                                                                    AppDefaults.shared.userLastName = responseModel.resultData?.LastName ?? ""
                                                                    //AppDefaults.shared.userJWT_Token = self.userData.body?.sessionToken ?? ""
                                                                    AppDefaults.shared.userEmail = responseModel.resultData?.Email ?? ""
                                                                 AppDefaults.shared.userPhoneNumber =  responseModel.resultData?.PhoneNo ?? ""
                                                                 UserDefaultExtensionModel.shared.currentUserId = responseModel.resultData?.UserId ?? 0
                                                                    AppDefaults.shared.userImage = responseModel.resultData?.ImageUrl ?? ""
                                                    AppDefaults.shared.bio = responseModel.resultData?.Bio ?? ""

                                           self.delegate?.signUpSuccess(message:msg)
                        
                    default:
                        if let msg = responseModel.message{
                            self.signUpView?.showAlert(alert: msg)
                        }
                    }
                }, completionError: { (err) in
                    self.signUpView?.showAlert(alert: err ?? "")
                })
          
                
            }) { (error) in
                self.signUpView?.showAlert(alert: error?.localizedDescription ?? "")
            }
        }
    }
    
    private func signUpResponseJson(data: [String : Any],completionResponse:  @escaping (VerifyOTP) -> Void,completionError: @escaping (String?) -> Void)  {
        let signUpData = VerifyOTP(JSON: data)
        if signUpData != nil{
            completionResponse(signUpData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func logout(userId: Int, deviceType: Int) {
    
    self.signUpView?.showLoader()
       
      HomeworkApi.sharedManager.likePost(url:"api/User/Logout?userId=\(userId)&deviceType=\(deviceType)" , parameters: nil, completionResponse: { (response) in
        strlogot = "logout"
             CommonFunctions.sharedmanagerCommon.setRootLogin()
                    self.signUpView?.hideLoader()
           
       }, completionnilResponse: { (nilResponse) in
        strlogot = "logout"
           CommonFunctions.sharedmanagerCommon.setRootLogin()
            self.signUpView?.hideLoader()
           
       }) { (error) in
        strlogot = "logout"
          CommonFunctions.sharedmanagerCommon.setRootLogin()
             self.signUpView?.hideLoader()
           }
       }
    
    func getUserByPhoneNumber(Phone: String, Email:String){
        self.signUpView?.showLoader()
        var postDict = [String:Any]()
        postDict["Phone"] = Phone
        postDict["Email"] = Email
        
        print("our params: ",postDict)
        
        SignUpApi.sharedInstance.getUserDetailByPhoneEmail(url: ApiEndpoints.kGetUserDetailByPhoneEmail, parameters: postDict, completionResponse: { (GetUserDetailByPhoneEmail) in
            if GetUserDetailByPhoneEmail.statusCode == KStatusCode.kStatusCode302{
                self.signUpView?.hideLoader()
                self.delegate?.GetUserDetailSuccess(data: GetUserDetailByPhoneEmail)
            }else{
                self.signUpView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "status change")
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.signUpView?.hideLoader()
            self.delegate?.DidFailedRoleMenu()
            
            if let error = nilResponseError{
                self.signUpView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            
            self.signUpView?.hideLoader()
            self.delegate?.DidFailedRoleMenu()
            if let err = error?.localizedDescription{
                self.signUpView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
            
        }
    }

    

}

