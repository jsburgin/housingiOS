//
//  Schedule.swift
//  housing
//
//  Created by Josh Burgin on 5/30/16.
//  Copyright © 2016 burgin.io. All rights reserved.
//

import UIKit

class Schedule: NSObject {
    
    struct Day {
        var name : String
        var events: Array<Event>
    }
    
    var days = Array<Day>()
    var currentDate : String
    
    override init() {
        self.currentDate = ""
    }
    
    func addEvent(newEvent: Event) {
        
        if newEvent.date != self.currentDate {
            let newDay = Day(name: newEvent.prettyDate.uppercaseString, events: Array<Event>())
            days.append(newDay)
            self.currentDate = newEvent.date
        }
        
        days[days.count - 1].events.append(newEvent)
    }
    
    func removeAll() {
        self.days = Array<Day>()
        self.currentDate = ""
    }
    
}
