//
//  AppUser.swift
//  EZSportsRP
//
//  Created by admin_user on 4/11/18.
//  Copyright © 2018 admin_user. All rights reserved.
//

import Foundation

class AppUser {
    var token: String!
    var id: Int!
    var username: String?
    var email: String?
    var password: String?
    var city: String?
    var country: String?
    var role: String!
    var phone: String?
    
    init() {
        id = nil
        token = nil
        email = nil
        password = nil
        username = nil
        city = nil
        country = nil
        role = nil
    }
    
    init(_ json: [String: Any]) {
        id = Int("\(json["id"]!)")
        token = json["token"] as? String
        email = json["email"] as? String
        password = json["password"] as? String
        username = json["username"] as? String
        role = json["role"] as? String
        city = json["city"] as? String
        country = json["country"] as? String
        phone = json["phone"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["id"] = id
        dict["token"] = token
        dict["email"] = email
        dict["password"] = password
        dict["username"] = username
        dict["role"] = role
        dict["city"] = city
        dict["country"] = country
        dict["phone"] = phone
        return dict
    }
    
    func saveToStorage() {
        LocalStorage["app_user"] = self.toDictionary()
    }
    
    static func getSavedUser() -> AppUser {
        if let dict = LocalStorage["app_user"].object as? [String: Any] {
            return AppUser(dict)
        }
        return AppUser()
    }
    
    static func isLogin() -> Bool {
        if getSavedUser().username == nil {
            return false
        }
        return true
    }
    
    static func clearStorage() {
        LocalStorage["app_user"] = nil
    }
    
    func isAdmin() -> Bool {
        if role.contains("admin") {        // 1
            return true
        }
        return false
    }

    func isEditor() -> Bool {
        if role.contains("editor") {        // 1
            return true
        }
        return false
    }
}
