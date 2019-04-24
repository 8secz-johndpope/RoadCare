//
//  APIDomains.swift
//  Roadcare
//
//  Created by macbook on 4/22/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import Foundation

class RegisterResponse {
    var code: Int!
    var message: String!
    
    init(_ json: [String: Any]) {
        code = Int("\(json["code"]!)")
        message = json["message"] as? String
    }
}

class AuthNonce {
    var status: String!
    var controller: String!
    var method: String!
    var nonce: String!
    
    init(_ json: [String: Any]) {
        status = json["status"] as? String
        controller = json["controller"] as? String
        method = json["method"] as? String
        nonce = json["nonce"] as? String
    }
}

class LoginResponse {
    var status: String!
    var error: String!
    var cookie: String!
    var cookie_name: String!
    var user: [String: Any]
    
    init(_ json: [String: Any]) {
        status = json["status"] as? String
        error = json["error"] as? String
        cookie = json["cookie"] as? String
        cookie_name = json["cookie_name"] as? String
        user = json["user"] as? [String: Any] ?? [:]
    }
}
