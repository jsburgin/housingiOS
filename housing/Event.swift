//
//  Event.swift
//  housing
//
//  Created by Josh Burgin on 5/26/16.
//  Copyright © 2016 burgin.io. All rights reserved.
//

import UIKit
import SwiftyJSON

class Event: NSObject {
    
    let title : String
    let desc: String
    let startTime: String
    let endTime: String?
    let location: String
    let date: String
    
    init (title: String, desc: String, startTime: String, endTime: String?, location: String, date: String) {
        self.title = title
        self.desc = desc
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.date = date
    }
    
    class func build(json: JSON) -> Event? {
        
        if let
            title = json["title"].string,
            desc = json["description"].string,
            startTime = json["prettyStartTime"].string,
            location = json["location"].string,
            date = json["date"].string {
            
            return  Event(
                title: title,
                desc: desc,
                startTime: startTime,
                endTime: json["prettyEndTime"].string,
                location: location,
                date: date
            )
            
        }
        
        return nil
    }
}
