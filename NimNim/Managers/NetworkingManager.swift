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
    private init() {
        
    }
    func get(withEndpoint endpoint:String?,withParams params:[String:Any]?, withSuccess success:((Any?)->Void)?, withFailure failure:((Error?) -> Void)?) {
        guard let endpoint = endpoint else {
            return
        }
        guard let url = URL(string: baseUrl + endpoint) else {
            return
        }

        Alamofire.request(url, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("Request:\(String(describing: response.request ?? nil))")
                print("Response:\(String(describing: response.result.value ?? nil))")
                success?(response.result.value) // call of closure
            }//kab hoga
            else {
                failure?(response.result.error) // call of closure
            }
        }
    }// definition of get
    
    func post(withEndpoint endpoint:String?,withParams params:[String:Any]?, withSuccess success:((Any?)->Void)?, withFailure failure:((Error?) -> Void)?) {
        guard let endpoint = endpoint else {
            return
        }
        guard let url = URL(string: baseUrl + endpoint) else {
            return
        }
        Alamofire.request(url, method: .post, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("Request:\(String(describing: response.request ?? nil))")
                print("Response:\(String(describing: response.result.value ?? nil))")
                success?(response.result.value)
            }
            else {
                failure?(response.result.error)
            }
        }
    }
}

//please explain the use



