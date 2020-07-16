//
//  QuestionsViewModel.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 6/2/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import Foundation

import UIKit

protocol QuestionAnswerDelegate:class {
    func QuestionAnswerSuccess(message: String)
    func GetQuestionAnswerSuccess(data: GetQuestionsModel )
    func GetMultipleQuestionSuccess(data: QuestionsChoiceModel )
    func GetSearchResult(data: GetSearchResultModel)
    func DidFailed()
    
}

class QuestionAnswerViewModel{
    weak var questionAnswerDelegate:QuestionAnswerDelegate?
    weak var questionView: ViewDelegate?
    
    init(delegate:QuestionAnswerDelegate){
        self.questionAnswerDelegate = delegate
    }
    //Attaching view
    func attachView(view: ViewDelegate) {
        questionView = view
    }
    //Detaching view
    func detachView() {
        questionView = nil
    }
    

    func getQuestionList (userId: Int) {
        self.questionView?.showLoader()
                let url = "api/Social/GetQuestions?userId=\(userId)"
        
        SignUpApi.sharedInstance.getQuestions(url: url, parameters: nil, completionResponse: { (response) in
             self.questionView?.hideLoader()
            if response.statusCode == 200 {
                
                self.questionAnswerDelegate?.GetQuestionAnswerSuccess(data: response)
                
            }
        }, completionnilResponse: { (error) in
            
            self.questionView?.hideLoader()
                      self.questionAnswerDelegate?.DidFailed()
            self.questionView?.showAlert(alert: error ?? "Something went wrong!")
                          
            
        }) { (error) in
            
            self.questionView?.hideLoader()
                  self.questionAnswerDelegate?.DidFailed()
                  if let err = error?.localizedDescription{
                      self.questionView?.showAlert(alert: err)
                  }else{
                      CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
                  }
                  
            
        }
    }
    
    func getMutipleQuestionList (userId: Int) {
        self.questionView?.showLoader()

                let url = "api/Social/GetChoiceQuestions?userId=\(userId)"
        
        SignUpApi.sharedInstance.getMultipleQuestions(url: url, parameters: nil, completionResponse: { (response) in
            self.questionView?.hideLoader()

            if response.statusCode == 200 {
                
                self.questionAnswerDelegate?.GetMultipleQuestionSuccess(data: response)
                
            }
        }, completionnilResponse: { (error) in
            
            self.questionView?.hideLoader()
                      self.questionAnswerDelegate?.DidFailed()
            self.questionView?.showAlert(alert: error ?? "Something went wrong!")
                          
            
        }) { (error) in
            
            self.questionView?.hideLoader()
                  self.questionAnswerDelegate?.DidFailed()
                  if let err = error?.localizedDescription{
                      self.questionView?.showAlert(alert: err)
                  }else{
                      CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
                  }
                  
            
        }
    }
    
    
    func saveQuestionAnswer (userId: Int, arrQues: NSMutableArray,TypeId: Int ) {
        self.questionView?.showLoader()

           let url = "api/Social/AddUpdateQuestionAnswers"
           var param = [String : Any]()
        param = [
        "userId" : userId,
        "TypeId": TypeId,
        "QuestionAnswers" : arrQues
            ] as [String : Any]
        
        SignUpApi.sharedInstance.AddQuestionAnswer(url: url, parameters: param, completionResponse: { (response) in
              if response["StatusCode"] as? Int == KStatusCode.kStatusCode200{
                  self.questionView?.hideLoader()
                 self.questionView?.showAlert(alert: response["Message"] as? String ?? "")
                 
              }
          }, completionnilResponse: { (nilResponseError) in
              
              self.questionView?.hideLoader()
              self.questionAnswerDelegate?.DidFailed()
              
              if let error = nilResponseError{
                  self.questionView?.showAlert(alert: error)
                  
              }else{
                  CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
              }
              
          }) { (error) in
              
              self.questionView?.hideLoader()
              self.questionAnswerDelegate?.DidFailed()
              if let err = error?.localizedDescription{
                  self.questionView?.showAlert(alert: err)
              }else{
                  CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
              }
              
          }
      }
    
    
    func saveMultipleQuestionAnswer (userId: Int, arrQues: NSMutableArray,TypeId: Int) {
      self.questionView?.showLoader()
        
//        var aa = Array<[String:Any]>()
//
//        for (index,value) in arrQues.enumerated() {
//            aa.append(value as! [String : Any])
//        }

         let url = "api/Social/AddUpdateChoiceQuestionAnswers"
         var param = [String : Any]()
      param = [
      "UserId" : "\(userId)",
        "TypeId": TypeId,
      "ChoiceQuestionAnswers" : arrQues] as [String : Any]
          
     
      SignUpApi.sharedInstance.AddQuestionAnswer(url: url, parameters: param, completionResponse: { (response) in
            if response["StatusCode"] as? Int == KStatusCode.kStatusCode200{
                self.questionView?.hideLoader()
                self.questionView?.showAlert(alert: response["Message"] as? String ?? "")
            }
            else{
                self.questionView?.hideLoader()
                self.questionView?.showAlert(alert: response["Message"] as? String ?? "")

        }
        }, completionnilResponse: { (nilResponseError) in
            
            self.questionView?.hideLoader()
            self.questionAnswerDelegate?.DidFailed()
            
            if let error = nilResponseError{
                 self.questionView?.hideLoader()
                self.questionView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            
            self.questionView?.hideLoader()
            self.questionAnswerDelegate?.DidFailed()
            if let err = error?.localizedDescription{
                self.questionView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
            
        }
    }

    
    func searchResult(Search: String, skip: Int, PageSize: Int, SortColumnDir : String, SortColumn: String, ParticularId: Int ) {
      
        self.questionView?.showLoader()

                  let url = "api/User/GetUserlist"
                  var param = [String : Any]()
               param = [
                "Search" : Search,
                "skip" : skip,
                "PageSize" : PageSize,
                "SortColumnDir" : SortColumnDir,
                "SortColumn" : SortColumn,
                "ParticularId" : ParticularId
                ] as [String : Any]
               
               SignUpApi.sharedInstance.getSearchData(url: url, parameters: param, completionResponse: { (response) in
                if response.statusCode == KStatusCode.kStatusCode200{
                    
                         self.questionView?.hideLoader()
                         self.questionAnswerDelegate?.GetSearchResult(data: response)
                    
                    
                     }
                 }, completionnilResponse: { (nilResponseError) in
                     
                     self.questionView?.hideLoader()
                     self.questionAnswerDelegate?.DidFailed()
                     
                     if let error = nilResponseError{
                         self.questionView?.showAlert(alert: error)
                         
                     }else{
                         CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
                     }
                     
                 }) { (error) in
                     
                     self.questionView?.hideLoader()
                     self.questionAnswerDelegate?.DidFailed()
                     if let err = error?.localizedDescription{
                         self.questionView?.showAlert(alert: err)
                     }else{
                         CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
                     }
                     
                 }
        
    }
    
//    func saveQuestionAnswer (userId: Int, arrQues: NSMutableArray) {
//
//         let url = "api/Social/AddUpdateQuestionAnswers"
//         var param = [String : Any]()
//      param = [
//      "userId" : userId,
//      "QuestionAnwsers" : arrQues] as [String : Any]
//
//      SignUpApi.sharedInstance.AddQuestionAnswer(url: url, parameters: param, completionResponse: { (response) in
//            if response["StatusCode"] as? Int == KStatusCode.kStatusCode200{
//                self.questionView?.hideLoader()
//               self.questionView?.showAlert(alert: response["Message"] as? String ?? "")
//
//            }
//        }, completionnilResponse: { (nilResponseError) in
//
//            self.questionView?.hideLoader()
//            self.questionAnswerDelegate?.DidFailed()
//
//            if let error = nilResponseError{
//                self.questionView?.showAlert(alert: error)
//
//            }else{
//                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
//            }
//
//        }) { (error) in
//
//            self.questionView?.hideLoader()
//            self.questionAnswerDelegate?.DidFailed()
//            if let err = error?.localizedDescription{
//                self.questionView?.showAlert(alert: err)
//            }else{
//                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
//            }
//
//        }
 //   }


}
