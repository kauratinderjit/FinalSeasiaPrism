//
//  LoginData.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 5/20/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import Foundation
import ObjectMapper


class LoginData: Mappable {
    
    var statusCode : Int?
    var status : Bool?
    var message : String?
    var resultData: Int?
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
