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
var SELECTED_POTHOLE_PHOTO = ""

let REPAIRED = "Repaired"
let NOT_REPAIRED = "Not Repaired"

struct ColorPalette {
    static let primary = UIColor(red: 38 / 255.0, green: 125 / 255.0, blue: 250 / 255.0, alpha: 1.0)
    static let primaryDark = UIColor(red: 126 / 255.0, green: 133 / 255.0, blue: 156 / 255.0, alpha: 1.0)
}

struct AppConstants {
    static var language: String = "English"
    static var country: String = "Palestine"
    static var city: String = "Nablus"
    static var authUser: AppUser = AppUser.getSavedUser()
    static var cities = [City]()
    
    static func getLanguage() -> String {
        if let lang = LocalStorage["app_language"].object as? String {
            return lang
        }
        return "English"
    }
    static func getCountry() -> String {
        if let country = LocalStorage["selected_country"].object as? String {
            return country
        }
        return ""
    }
    static func getCity() -> String {
        if let city = LocalStorage["selected_city"].object as? String {
            return city
        }
        return ""
    }
    
    static func getIdByCity(_ name: String) -> Int? {
        for city in cities {
            if city.name == name {
                return city.id
            }
        }
        return nil
    }
}

struct ResponseCode {
    static let cancelled = "cancelled"
}

struct Location {
    static var city: String = ""
    static var country: String = ""
    static var detectedCity: String = ""
}


let APPLE_LANGUAGE_KEY = "AppleLanguages"

class AppLanguage {
    /// get current Apple language
    class func currentAppleLanguage() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
}
