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
    
    class func getSchedule(apiKey : String, next: (JSON?, NSError?) -> ()) {
        
        var params = [String: String]()
        params["apiKey"] = apiKey
        
        executeRequest(.GET, encoding: .URL, urlExtender: "schedule", params: params, next: next)
        
    }
    
    class func registerDeviceToken(email: String, deviceToken: String) {
        var userData = [String: String]()
        userData["email"] = email
        userData["devicetoken"] = deviceToken
        
        executeRequest(.POST, encoding: .JSON, urlExtender: "devicetoken", params: userData) { data, error in
            if let err = error {
                print(err)
            }
        }
    }
    
    class func authenticate(idToken: String, next: (JSON?, NSError?) -> ()) {
        var user = [String: String]()
        user["idToken"] = idToken
        user["type"] = "ios"
        
        executeRequest(.POST, encoding: .JSON, urlExtender: "authenticate", params: user, next: next)
    }
    
    class func executeRequest(requestType: Alamofire.Method, encoding: Alamofire.ParameterEncoding, urlExtender: String, params: Dictionary<String, String>, next: (JSON?, NSError?) -> ()) {
        
        
        Alamofire.request(requestType, baseURL + urlExtender, parameters: params, encoding: encoding)
            .validate()
            .responseJSON { request in
                
                if request.result.isSuccess {
                    
                    if let value = request.result.value {
                        
                        next(JSON(value), nil)
                        return
                    }
                }
                
                if request.result.isFailure {
                    next(nil, request.result.error)
                }
                
            }
    }
    
}
