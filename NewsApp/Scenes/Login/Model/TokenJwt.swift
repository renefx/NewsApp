//
//  TokenJwt.swift
//  NewsApp
//
//  Created by Renê Xavier on 25/01/21.
//

import Foundation

struct TokenJwt: Codable {
    static var currentToken: String?
    var token: String?
}
