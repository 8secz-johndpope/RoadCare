//
//  Constants.swift
//  Roadcare
//
//  Created by macbook on 4/7/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import Foundation
import UIKit

var AppVersion = "1.0"
var POTHOLE_ID: Int = 0

let REPAIRED = "Repaired"
let NOT_REPAIRED = "Not Repaired"

struct ColorPalette {
    static let primary = UIColor(red: 38 / 255.0, green: 125 / 255.0, blue: 250 / 255.0, alpha: 1.0)
    static let primaryDark = UIColor(red: 126 / 255.0, green: 133 / 255.0, blue: 156 / 255.0, alpha: 1.0)
}

struct AppConstants {
    static var language: String = "English"
    static var authUser: AppUser = AppUser.getSavedUser()
    
    static func getLanguage() -> String {
        if let lang = LocalStorage["app_language"].object as? String {
            return lang
        }
        return "English"
    }
}

struct ResponseCode {
    static let cancelled = "cancelled"
}

struct Location {
    static var city: String = ""
    static var country: String = ""
}
