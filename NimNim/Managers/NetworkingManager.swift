//
//  NetworkingManager.swift
//  NimNim
//
//  Created by Raghav Vij on 09/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingManager {
    //static variables are class variables...they are a part of memory that class needs to exists...these variables can be accessed only by the class names and not by object of the classes...when classes are compiled they occupy a certain amount of memory...static variables of that class are a part of that memory...vs instance variables of classes occupy memory when objects are created of those classes ie at runtime...
    
    static let shared = NetworkingManager() //shared will be reference to the only object that will be created for this class...hence shared is a reference to the singleton object of this class...we have made this class as a singleton class by making the initializer of the class private...
    
    // Making the init of this class as private will ensure that no one from outside this class can initialize it...
    let baseUrl = "http://www.getnimnim.us:3000/"
    private init() {}
    
    struct PostEncoding:ParameterEncoding {
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var request = try urlRequest.asURLRequest()
            if let parameters = parameters {
                let parameterData = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = String(data: parameterData,
                                        encoding: .utf8)
                request.httpBody = jsonString?.data(using: .utf8, allowLossyConversion: false)
            }
            return request
        }
    }
    
    func get(withEndpoint endpoint:String?,withParams params:[String:Any]?, withSuccess success:((Any?)->Void)?, withFailure failure:((Any?) -> Void)?) {
        guard let endpoint = endpoint else {
            return}
        guard let url = URL(string: baseUrl + endpoint) else {
            return}
        var headers : HTTPHeaders = [:]
        if let userModel = UserModel.fetchFromUserDefaults(){
            if let token = userModel.token{
                let finaltoken = token
                headers = ["Authorization":"Bearer \(finaltoken)"]
            }
        }
        Alamofire.request(url, method: .get, parameters: params, headers : headers).responseJSON{
            response in
            guard let statusCode = response.response?.statusCode else {
                failure?(nil)
                return
            }
            print("Request:\(String(describing: response.request ?? nil))")
            print("Response:\(String(describing: response.result.value ?? nil))")
            
            if statusCode >= 200 && statusCode < 400 {
                success?(response.result.value) // call of closure
            }else {
                if let responseValue = response.result.value as? [String:Any] {
                    if let error = responseValue["error"] as? String {
                        failure?(error) // call of closure
                    }
                }
            }
        }
    }// definition of get
    
    func post(withEndpoint endpoint:String?,withParams params:[String:Any]?, withSuccess success:((Any?)->Void)?, withFailure failure:((Any?) -> Void)?) {
        guard let endpoint = endpoint else {
            return
        }
        guard let url = URL(string: baseUrl + endpoint) else {
            return
        }
        var headers : [String:String] = [:]
        if let userModel = UserModel.fetchFromUserDefaults(){
            if let token = userModel.token{
                headers = ["Authorization":"Bearer \(token)",
                    "Content-Type":"application/json"
                ]
            }
        }
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers : headers ).responseJSON {
            response in
            guard let statusCode = response.response?.statusCode else {
                failure?(nil)
                return
            }
            print("Request:\(String(describing: response.request ?? nil))")
            print("Response:\(String(describing: response.result.value ?? nil))")
            
            if statusCode >= 200 && statusCode < 400 {
                print("success")
                success?(response.result.value) // call of closure
            }else {
                print("error")
                if let responseValue = response.result.value as? [String:Any] {
                    if let error = responseValue["error"] as? String {
                        failure?(error) // call of closure
                    }
                }
            }
        }
    }
}


//please explain the use



