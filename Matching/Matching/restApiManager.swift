//
//  restApiManager.swift
//  Matching
//
//  Created by Tran Anh on 7/26/16.
//  Copyright © 2016 Tran Anh. All rights reserved.
//

import Foundation
typealias ServiceRespone = (JSON, NSError?) -> Void
class restApiManager: NSObject {
    static let sharedInstance = restApiManager()
    
    let baseURL = "http://192.168.1.47:8080/api/v1/"
    func getRandomLocation(baseLocationURL: String, rad:Int, onComletion: (JSON) -> Void){
        let route = baseURL + "\(baseLocationURL)&rad=\(rad)"
        makeHTTPGetRequest(route, onCompletion: { json, err in onComletion(json as JSON)
        
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceRespone) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
//            guard error == nil && data != nil else {                                                          // check for fundamental networking error
//                print("error=\(error)")
//                return
//            }
//            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            } else {
                let json:JSON = JSON(data: data!)
                onCompletion(json, error)
//            }
 
            
            
        })
        task.resume()
    }

}
