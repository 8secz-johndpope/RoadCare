//
//  AppUser.swift
//  RoadCare
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
    var meta_box: UserMetaBox
    var city: String?
    var country: String?
    var role: String!
    var phone: String?
    var notification_id: String?
    
    init() {
        id = nil
        token = nil
        email = nil
        password = nil
        username = nil
        city = nil
        country = nil
        role = nil
        notification_id = nil
        meta_box = UserMetaBox()
    }
    
    init(_ json: [String: Any]) {
        id = Int("\(json["id"]!)")
        token = json["token"] as? String
        email = json["email"] as? String
        password = json["password"] as? String
        username = json["username"] as? String
        role = json["role"] as? String
        let child_json = json["meta_box"] as? [String: Any] ?? [:]
        meta_box = UserMetaBox(child_json)
        city = meta_box.city
        country = meta_box.country
        phone = meta_box.phone
        notification_id = meta_box.notification_id
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
