//
//  MediaDetails.swift
//  Roadcare
//
//  Created by macbook on 5/7/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import Foundation

class MediaDetails {
    var id: Int!
    var status: String?
    var date: String?
    var modified: String?
    var url: String?
    var guid: [String: Any]?

    init() {
        id = nil
        guid = nil
    }
    
    init(_ json: [String: Any]) {
        id = Int("\(json["id"]!)")
        date = json["date"] as? String
        modified = json["modified"] as? String
        status = json["status"] as? String
        let guid = json["guid"] as? [String: Any]
        let content = GuidContent(guid!)
        url = content.rendered
    }
}

class GuidContent {
    var rendered: String?
    var raw: String?
    
    init(_ json: [String: Any]) {
        rendered = json["rendered"] as? String
        raw = json["raw"] as? String
    }
}
