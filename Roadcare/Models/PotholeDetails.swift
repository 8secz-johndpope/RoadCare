//
//  AppUser.swift
//  RoadCare
//
//  Created by admin_user on 4/11/18.
//  Copyright © 2018 admin_user. All rights reserved.
//

import Foundation

class PotholeDetails {
    var id: Int!
    var title: String!
    var status: String?
    var date: String?
    var modified: String?
    var metaBox: MetaBox?
    
    init() {
        id = nil
        title = nil
        status = nil
        metaBox = MetaBox()
    }
    
    init(_ json: [String: Any]) {
        id = Int("\(json["id"]!)")
        let raw = json["title"] as? [String: Any]
        let a = Title(raw!)
        title = a.rendered
        date = json["date"] as? String
        modified = json["modified"] as? String
        status = json["status"] as? String
        metaBox = MetaBox(json["meta_box"] as? [String: Any] ?? [:])
    }
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["title"] = title
        dict["status"] = status
        dict["meta_box"] = metaBox?.toDictionary()
        return dict
    }
}

class Title {
    var rendered: String?
    
    init(_ json: [String: Any]) {
        rendered = json["rendered"] as? String
    }
}
