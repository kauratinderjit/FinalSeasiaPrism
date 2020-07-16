//
//  LoginApi.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 5/20/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import Foundation
import Alamofire

class LoginApi
{
    //MARK:- variables
    static let sharedmanagerAuth = LoginApi()
    
    private init()
    {
    }
    
    
    //MARK:- Login Api
    func LogInApi(url : String, parameter : [String:Any]?, completionResponse:  @escaping (LoginData) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void)
    {
            let urlComplete = BaseUrl.kBaseURL+url
            let headers    = [KConstants.kContentType : KConstants.kApplicationJson]
            
            print("url: ",urlComplete)
            Alamofire.request(urlComplete, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers : headers)
                .responseJSON { response in
                  
                    print(response)
                    if response.result.isSuccess
                    {
                        guard let data = response.value else{return}
                        
                        if let responseData  = data as? [String : Any]
                        {
                            self.userDataJSON(data: responseData, completionResponse: { (UserData) in
                                completionResponse(UserData)
                            }, completionError: { (error) in
                                CommonFunctions.sharedmanagerCommon.println(object: error!)
                                
                            })
                        }else
                        {
                            completionnilResponse(k_ServerError)
                        }
                    
                    }
                    else
                    {
                        completionError(response.error)
                        return
                    }
            }
            
        }
    
    //using For Login User Json Response convert into model
       private func userDataJSON(data: [String : Any],completionResponse:  @escaping (LoginData) -> Void,completionError: @escaping (Error?) -> Void)  {
           
           
           let user = LoginData(JSON: data)
           
           completionResponse(user!)
           
       }
    
    func verifyOTP(url : String, parameter : [String:Any]?, completionResponse:  @escaping (VerifyOTP) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void)
    {
            let urlComplete = BaseUrl.kBaseURL+url
            let headers    = [KConstants.kContentType : KConstants.kApplicationJson]
            
            
            Alamofire.request(urlComplete, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers : headers)
                .responseJSON { response in
                  
                    print(response)
                    if response.result.isSuccess
                    {
                        guard let data = response.value else{return}
                        
                        if let responseData  = data as? [String : Any]
                        {
                            self.verifyOTPJSON(data: responseData, completionResponse: { (UserData) in
                                completionResponse(UserData)
                            }, completionError: { (error) in
                                CommonFunctions.sharedmanagerCommon.println(object: error!)
                                
                            })
                        }else
                        {
                            completionnilResponse(k_ServerError)
                        }
                    
                    }
                    else
                    {
                        completionError(response.error)
                        return
                    }
            }
            
        }
    
    //using For Login User Json Response convert into model
       private func verifyOTPJSON(data: [String : Any],completionResponse:  @escaping (VerifyOTP) -> Void,completionError: @escaping (Error?) -> Void)  {
           
           
           let user = VerifyOTP(JSON: data)
           
           completionResponse(user!)
           
       }
}
