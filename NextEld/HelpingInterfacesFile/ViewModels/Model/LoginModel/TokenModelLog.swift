//
//  TokenModelLog.swift
//  NextEld
//
//  Created by priyanshi on 18/06/25.
//

import Foundation

struct TokenModelLog : Codable {
    let result : Result?
    let arrayData : String?
    let status : String?
    let message : String?
    let token : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case arrayData = "arrayData"
        case status = "status"
        case message = "message"
        case token = "token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Result.self, forKey: .result)
        arrayData = try values.decodeIfPresent(String.self, forKey: .arrayData)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

}
