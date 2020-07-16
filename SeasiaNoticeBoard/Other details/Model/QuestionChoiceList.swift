//
//  QuestionChoiceList.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 6/2/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import ObjectMapper


class QuestionsChoiceModel : Mappable{
        
        var message : String?
        var status : Bool?
        var statusCode :  Int?
        var resultData : [QuestionChoiceListData]?
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
    
    struct QuestionChoiceListData: Mappable {
        
        var ChoiceQuestionId : Int?
        var Option1 : String?
        var Option2 : String?
        var ChoiceQuestionAnswerId : Int?
        var Selected : String?

        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
       
            ChoiceQuestionId <- map["ChoiceQuestionId"]
            Option1 <- map["Option1"]
            Option2 <- map["Option2"]
            ChoiceQuestionAnswerId <- map["ChoiceQuestionAnswerId"]
            Selected <- map["Selected"]
           
        }
        
    }

