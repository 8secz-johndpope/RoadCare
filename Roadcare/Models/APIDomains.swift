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

class FileUpload {
    var file: String?
    
    init() {
        file = nil
    }
}

class MetaBox {
    var address: String!
    var street_name: String!
    var city: String!
    var country: String!
    var nearby_places: String!
    var reporter_name: String!
    var phone_number: String!
    var reported_number: String!
    var repaired_status: String!
    var repaired_name: String!
    var pothole_photo: String!
    var audio: String!
    var lat: String!
    var lng: String!
    
    init() {
        
    }
    
    init(_ json: [String: Any]) {
        address = json["address"] as? String
        street_name = json["street_name"] as? String
        city = json["city"] as? String
        country = json["country"] as? String
        nearby_places = json["nearby_places"] as? String
        reporter_name = json["reporter_name"] as? String
        phone_number = json["phone_number"] as? String
        reported_number = json["reported_number"] as? String
        repaired_status = json["repaired_status"] as? String
        repaired_name = json["repaired_name"] as? String
        pothole_photo = json["pothole_photo"] as? String
        audio = json["audio"] as? String
        lat = json["lat"] as? String
        lng = json["lng"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["address"] = address
        dict["street_name"] = street_name
        dict["city"] = city
        dict["country"] = country
        dict["nearby_places"] = nearby_places
        dict["reporter_name"] = reporter_name
        dict["phone_number"] = phone_number
        dict["reported_number"] = reported_number
        dict["repaired_status"] = repaired_status
        return dict
    }
}

class GroupedPotholes{
    var city: String
    var country: String
    var report_array: [PotholeDetails]
    
    init(city: String, country: String){
        self.city = city
        self.country = country
        report_array = []
    }
}

class GroupedPRRTPotholes {
    var city: String
    var country: String
    var prrt: Double
    
    init(city: String, country: String, prrt: Double) {
        self.city = city
        self.country = country
        self.prrt = prrt
    }
}

class City {
    var id: Int!
    var name: String
    var country: String
    
    init(_ json: [String: Any]) {
        id = Int("\(json["id"]!)")
        name = (json["name"] as? String)!
        country = (json["description"] as? String)!
    }
}

