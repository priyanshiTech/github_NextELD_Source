//
//  DefectAPicalling.swift
//  NextEld
//
//  Created by priyanshi on 19/08/25.
//

import Foundation
//MARK: -  DefectModel Rquest

struct DefectAPIRequestModel : Codable {
    let clientId: Int
    let defectId: Int
    let driverId : Int
    let tokenNo: String
    
}


//MARK: -  DefectAPI Responce Mdoel

struct DefectAPIResponceMdoel : Codable {
    let result : [ResultDefect]?
    let arrayData : String?
    let status : String?
    let message : String?
    let token : String?

}
struct ResultDefect : Codable {
    let defectId : Int?
    let defectName : String?
    let defectType : String?
    let clientId : Int?
    let addedTimestamp : Int?
    let updatedTimestamp : Int?

    var id: Int { defectId ?? UUID().hashValue }
}

