//
//  DefaultServerError.swift
//  NewsApp
//
//  Created by Renê Xavier on 26/01/21.
//

import Foundation

struct DefaultServerError: Error, Codable {
    var message: String
    var statusCode: Int?
    
    private enum CodingKeys : String, CodingKey {
        case message = "erro"
    }
    
    var messageUser: String {
        guard let statusCode = statusCode else {
            return message
        }
        return "\(message) (\(statusCode))"
    }
}
