//
//  UserLogin.swift
//  NewsApp
//
//  Created by Renê Xavier on 24/01/21.
//

import Foundation

struct UserLogin: Codable {
    var username: String
    var password: String
    
    private enum CodingKeys : String, CodingKey {
        case username = "user", password = "pass"
    }
}
