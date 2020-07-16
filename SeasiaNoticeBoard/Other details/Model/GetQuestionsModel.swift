//
//  GetQuestionsModel.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 6/2/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import Foundation
import ObjectMapper


class GetQuestionsModel : Mappable{
        
        var message : String?
        var status : Bool?
        var statusCode :  Int?
        var resultData : [QuestionListData]?
        var resourceType : String?
        
    
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            message <- map[KApiParameters.KCommonResponsePerameters.kMessage]
            status <- map[KApiParameters.KCommonResponsePerameters.kStatus]
            statusCode <- map[KApiParameters.KCommonResponsePerameters.kStatusCode]
            resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
            resourceType <- map[KApiParameters.KCommonResponsePerameters.kResourceType]
        }
        
    }
    
    struct QuestionListData: Mappable {
        
        var QuestionId : Int?
        var Question : String?
        var QuestionAnswerId : Int?
        var Answer : String?
       

        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
       
            QuestionId <- map["QuestionId"]
            Question <- map["Question"]
            QuestionAnswerId <- map["QuestionAnswerId"]
            Answer <- map["Answer"]
            
           
        }
        
    }

