//
//  VerifyOTP.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 5/20/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper


class VerifyOTP: Mappable {
    
    var statusCode : Int?
    var status : Bool?
    var message : String?
    var resultData: UserData?
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
//User Address
   struct UserData : Mappable {
       
    var UserId: Int?
    var ImageUrl : String?
    var ThumbImageUrl : String?
    var FirstName : String?
    var LastName : String?
    var PhoneNo : String?
    var Address: String?
    var Email: String?
    var Gender : String?
    var DOB: String?
    var City : String?
    var CityId : Int?

    var Password : String?
    var IsRegister: Bool?
    var CreatedDate: String?
    var CreatedBy: String?
    var ModifiedDate: String?
    var ModifiedBy: String?
    var IsActive: String?
    var IsDeleted: Bool?
     var Bio: String?
     
       
       init?(map: Map) {
       }
      
       
       mutating func mapping(map: Map) {
        
           UserId <- map["UserId"]
           ImageUrl <- map["ImageUrl"]
           ThumbImageUrl <- map["ThumbImageUrl"]
           FirstName <- map["FirstName"]
           LastName <- map["LastName"]
           PhoneNo <- map["PhoneNo"]
           Address <- map["Address"]
           Email <- map["Email"]
           Gender <- map["Gender"]
           DOB <- map["DOB"]
           City <- map["City"]
           CityId <- map["CityId"]
           Password <- map["Password"]
           IsRegister <- map["IsRegister"]
           CreatedDate <- map["CreatedDate"]
           CreatedBy <- map["CreatedBy"]
           ModifiedDate <- map["ModifiedDate"]
           IsActive <- map["IsActive"]
           IsDeleted <- map["IsDeleted"]
           Bio <- map["Bio"]
       }
   }
