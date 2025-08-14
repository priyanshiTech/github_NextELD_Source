//
//  Co-DriverModel.swift
//  NextEld
//
//  Created by priyanshi on 13/08/25.


import Foundation

//MARK: - Co-driver API Responce Model
struct CodriverModel : Codable {
    let result : [CodriverEmployee]?
    let arrayData : String?
    let status : String?
    let message : String?
    let token : String?
}

struct CodriverEmployee : Codable {
    let employeeId : Int?
    let title : String?
    let firstName : String?
    let lastName : String?
    let email : String?
}
