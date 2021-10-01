//
//  TmdbResponse.swift
//  Example
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import Foundation

struct TmdbResponse: Codable {
    let statusMessage: String?
    let id: String?
    let success: Int?
    let errorMessage: String?
    let statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case id, success
        case errorMessage = "error_message"
        case statusCode = "status_code"
    }
}
