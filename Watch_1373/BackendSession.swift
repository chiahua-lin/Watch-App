//
//  BackendSession.swift
//  Watch_1373
//
//  Created by William LaFrance on 5/8/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation

private enum BackendEndpoints {
    static let CreateUser = NSURL(string: "https://jssdev.exosite.com/api/portals/v1/users")!
}

public struct BackendSessionAuthentication {
    let username: String
    let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    public var headerValue: String {
        let base64Token = "\(username):\(password)".dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!.base64EncodedStringWithOptions(nil)
        return "Basic \(base64Token)"
    }
}

private enum BackendSessionSingleton {
    static let singleton = BackendSession()
}

class BackendSession {
    class func sharedInstance() -> BackendSession {
        return BackendSessionSingleton.singleton
    }

    let urlSession = NSURLSession.sharedSession()

    var authentication: BackendSessionAuthentication? {
        didSet {
            // If authentication is nil, blank headers, otherwise add Authorization header.
            urlSession.configuration.HTTPAdditionalHeaders = authentication.map { return ["Authorization" : $0.headerValue] } ?? [:]
        }
    }

    func createAccount(#emailAddress: String, password: String, completionHandler: (Result<AnyObject, NSError?>) -> ()) {
        var bodySerializationError: NSError?
        let body: [NSString : NSString] = ["email": emailAddress, "password": password]
        if let bodyData = NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.allZeros, error: &bodySerializationError) {
            let request = NSMutableURLRequest(URL: BackendEndpoints.CreateUser)
            request.HTTPMethod = "POST"
            request.HTTPBody = bodyData

            let task = urlSession.dataTaskWithRequest(request, completionHandler: { data, response, error in
                if let data = data {
                    var responseDeserializationError: NSError?
                    if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &responseDeserializationError) {
                        completionHandler(Result.Success(jsonObject))
                    } else {
                        completionHandler(Result.Failure(responseDeserializationError))
                    }
                } else {
                    completionHandler(Result.Failure(error))
                }
            })
            task.resume()
            LSRLog(.Exosite, .Info, "Sent request for .CreateUser")
        } else {
            LSRLog(.Exosite, .Error, "Failed to serialize body for .CreateUser with error: \(bodySerializationError), body: \(body)")
            completionHandler(Result.Failure(bodySerializationError))
        }
    }
}
