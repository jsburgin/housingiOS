//
//  Retriever.swift
//  housing
//
//  Created by Josh Burgin on 5/26/16.
//  Copyright © 2016 burgin.io. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Retriever: NSObject {
    
    static let baseURL = "https://uahousing.burgin.io/api/"
    
    class func getSchedule(email : String, next: (JSON?, NSError?) -> ()) {
        
        var params = [String: String]()
        params["email"] = email
        
        Alamofire.request(.GET, baseURL + "schedule", parameters: params).responseJSON { request in
            
            switch request.result {
                case .Success(let value):
                    next(JSON(value), nil)
                case .Failure(let error):
                    next(nil, error)
            }
            
        }
        
    }
}
