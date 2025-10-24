//
//  APIClient.swift
//  NextEld
//  Created by priyanshi on 18/06/25.
//

import Foundation

protocol APIClient {
    func request<T: Decodable>(
        _ endpoint: API.Endpoint,
        body: Data?
    ) async throws -> T
}
