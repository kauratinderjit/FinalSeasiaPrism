//
//  GetAllCountryApi.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 6/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper


class SignUpApi {
  
    //MARK:- variables
    static let sharedInstance = SignUpApi()
    

    //MARK:- Get Common api
    func getCommonDropdownApi(url : String, parameter : [String:Any]?, completionResponse:  @escaping (GetCommonDropdownModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,Error: @escaping (Error?) -> Void)
    {
        
        print(parameter)
        
        let urlComplete = BaseUrl.kBaseURL + url
        let headers    = [KConstants.kContentType : KConstants.kApplicationJson]
        
        print(urlComplete)
        
        Alamofire.request(urlComplete, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers : headers)
            .responseJSON { response in
                
                if response.result.isSuccess
                {
                    guard let data = response.value else{return}
                    
                    if let responseData  = data as? [String : Any]
                    {
                        print(responseData)
                        self.countryDataJSON(data: responseData, completionResponse: { (data) in
                            
                            if data.statusCode == 200{
                                completionResponse(data)
                            }
                            if data.statusCode == 400{
                                completionnilResponse(data.message)
                            }
                            
                        }, completionError: { (error) in
                            CommonFunctions.sharedmanagerCommon.println(object: "All Country Mapper Error:- ")
                            print()
                            completionnilResponse(error)
                        })
                        
                        
                    }
                   
                    
                }
                else
                {
                    Error(response.error)
                    return
                }
        }
        
    }
    
    //MARK:- Sign Up User Using MultiPart Api
    func multipartApi( postDict: [String: Any], url: String, completionResponse:  @escaping ([String: Any]) -> Void,completionError: @escaping (Error?) -> Void )
    {

        CommonFunctions.sharedmanagerCommon.println(object: "Post dictionary:- \(postDict)")
        
        let url = BaseUrl.kBaseURL+url
        print(url)
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        let headers: HTTPHeaders = [KConstants.kContentType: KConstants.kMultipartFormData,KConstants.kAccept : KConstants.kApplicationJson,KConstants.kHeaderAuthorization: KConstants.kHeaderBearer + " " + accessTokken]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1200
        let alamoManager = Alamofire.SessionManager(configuration: configuration)
        
        
        alamoManager.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in postDict {
                print(key)
                print(value)
                if value is URL{
                    
                    if let url = value as? URL{
                        multipartFormData.append(url, withName: key as String)
                    }
                    
                }
                else
                {
                    if let Item = value as? String
                    {
                        print(Item)
                        multipartFormData.append("\(Item)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    if let Item = value as? Int
                    {
                        print(Item)
                        multipartFormData.append("\(Item)".data(using: String.Encoding.utf8)!, withName: key as String)
                        
                    }
                }
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    print(response)
                    
                    
                    print(response.request ?? "")  // original URL request
                    print(response.response ?? "") // URL response
                    print(response.data ?? "")     // server data
                    print(response.result)   // result of response serialization
                    print(response.result.value ?? "" )
                    if let error = response.error
                    {
                        CommonFunctions.sharedmanagerCommon.println(object: "Upload failed with error: (\(error))")
                        CommonFunctions.sharedmanagerCommon.println(object: "Upload failed with error: (\(error.localizedDescription))")

                        completionError(response.error)
                    }
                    else
                    {
                        let resdict =  (response.result.value as!  [String : Any])
                        CommonFunctions.sharedmanagerCommon.println(object: "here your uploaded result23: \(resdict)")
                        completionResponse(resdict)
                    }
                    
                    alamoManager.session.invalidateAndCancel()
                }
            case .failure(let error):
                CommonFunctions.sharedmanagerCommon.println(object: "Errorss in upload: \(error.localizedDescription)")
                completionError(error)
                
            }
        }
        
    }
    

    private func countryDataJSON(data: [String : Any],completionResponse:  @escaping (GetCommonDropdownModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let countryData = GetCommonDropdownModel(JSON: data)
        
        if countryData != nil{
            completionResponse(countryData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
        
    }
    
    
    func getUserDetailByPhoneEmail(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetUserDetailByPhoneEmail) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        print("user : ",urlCmplete)
        
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer + " " + accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    print("responseData: ",responseData)
                    self.getUserDetailIdJSON(data: responseData, completionResponse: { (responseModel) in
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get User Access Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
    }
    
    private func getUserDetailIdJSON(data: [String : Any],completionResponse:  @escaping (GetUserDetailByPhoneEmail) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let getUserDetailData = GetUserDetailByPhoneEmail(JSON: data)
        
        if getUserDetailData != nil{
            completionResponse(getUserDetailData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
   
    func getQuestions(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetQuestionsModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
           
           let urlCmplete = BaseUrl.kBaseURL+url
           print("user : ",urlCmplete)
           
           var accessTokken = ""
           if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
           {
               accessTokken = str
           }
           
           let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
           
           
           Alamofire.request(urlCmplete, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
               print(response)
               if response.result.isSuccess
               {
                   guard let data = response.value else{return}
                   
                   if let responseData  = data as? [String : Any]
                   {
                       print("responseData: ",responseData)
                       self.getQuestionsAnswersJSON(data: responseData, completionResponse: { (responseModel) in
                           completionResponse(responseModel)
                       }, completionError: { (mapperError) in
                           completionnilResponse(mapperError)
                       })
                       
                   }else{
                       CommonFunctions.sharedmanagerCommon.println(object: "Get User Access Error:- \(data) ")
                   }
                   
               }
               else
               {
                   complitionError(response.error)
                   return
               }
           }
           
       }
    
    private func getQuestionsAnswersJSON(data: [String : Any],completionResponse:  @escaping (GetQuestionsModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let getUserDetailData = GetQuestionsModel(JSON: data)
        
        if getUserDetailData != nil{
            completionResponse(getUserDetailData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
    func getMultipleQuestions(url : String,parameters: [String : Any]?,completionResponse:  @escaping (QuestionsChoiceModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
              
              let urlCmplete = BaseUrl.kBaseURL+url
              print("user : ",urlCmplete)
              
              var accessTokken = ""
              if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
              {
                  accessTokken = str
              }
              
              let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
              
              
        Alamofire.request(urlCmplete, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                  print(response)
                  if response.result.isSuccess
                  {
                      guard let data = response.value else{return}
                      
                      if let responseData  = data as? [String : Any]
                      {
                          print("responseData: ",responseData)
                          self.getMultipleQuestionsAnswersJSON(data: responseData, completionResponse: { (responseModel) in
                              completionResponse(responseModel)
                          }, completionError: { (mapperError) in
                              completionnilResponse(mapperError)
                          })
                          
                      }else{
                          CommonFunctions.sharedmanagerCommon.println(object: "Get User Access Error:- \(data) ")
                      }
                      
                  }
                  else
                  {
                      complitionError(response.error)
                      return
                  }
              }
              
          }
       
       private func getMultipleQuestionsAnswersJSON(data: [String : Any],completionResponse:  @escaping (QuestionsChoiceModel) -> Void,completionError: @escaping (String?) -> Void)  {
           
           let getUserDetailData = QuestionsChoiceModel(JSON: data)
           
           if getUserDetailData != nil{
               completionResponse(getUserDetailData!)
           }else{
               completionError(Alerts.kMapperModelError)
           }
       }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func AddQuestionAnswer(url : String,parameters: [String : Any]?,completionResponse:  @escaping ([String: Any]) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        print("user : ",urlCmplete)
        
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        print(parameters)
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer + " " + accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
                
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    print("responseData: ",responseData)
                    completionResponse(response.value as! [String : Any])
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get User Access Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
    }
    
    
    func getSearchData(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetSearchResultModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
              
              let urlCmplete = BaseUrl.kBaseURL+url
              print("user : ",urlCmplete)
              
              var accessTokken = ""
              if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
              {
                  accessTokken = str
              }
              
              let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
              print(parameters)
              
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                  print(response)
                  if response.result.isSuccess
                  {
                      guard let data = response.value else{return}
                      
                      if let responseData  = data as? [String : Any]
                      {
                          print("responseData: ",responseData)
                          self.getSearchDataJSON(data: responseData, completionResponse: { (responseModel) in
                              completionResponse(responseModel)
                          }, completionError: { (mapperError) in
                              completionnilResponse(mapperError)
                          })
                          
                      }else{
                          CommonFunctions.sharedmanagerCommon.println(object: "Get User Access Error:- \(data) ")
                      }
                      
                  }
                  else
                  {
                      complitionError(response.error)
                      return
                  }
              }
              
          }
       
       private func getSearchDataJSON(data: [String : Any],completionResponse:  @escaping (GetSearchResultModel) -> Void,completionError: @escaping (String?) -> Void)  {
           
           let getUserDetailData = GetSearchResultModel(JSON: data)
           if getUserDetailData != nil {
               completionResponse(getUserDetailData!)
           }else{
               completionError(Alerts.kMapperModelError)
           }
       }
}

