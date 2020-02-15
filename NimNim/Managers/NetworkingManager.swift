//
//  NetworkingManager.swift
//  NimNim
//
//  Created by Raghav Vij on 09/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum MimeType:String { //  by default :Int . There are two values which can be associated with any case in enum that are hash and raw. In this case "image/png" and "image/jpeg" are raw values associated with case imagePng and imageJpeg respeectively . Similarly  Hash Values are 0 and 1 respectively.
    case imagePng = "image/png"
    case imageJpeg = "image/jpg"
}
enum ContentType:String {
    case MutltiPartFormData = "multipart/form-data"
}

class UploadModel:NSObject { //NSobect is the super parent class. Whenever we make model we use this.
    var data:Data? // Binary data for file to be uploaded
    var name:String? //key to be used for uploading the file...here it will be "image"
    var fileName:String? // the name of the file to be used on server
    var mimeType:MimeType? // type that can describe the file...like jpg...png etc.
}

class NetworkingManager {
    //static variables are class variables...they are a part of memory that class needs to exists...these variables can be accessed only by the class names and not by object of the classes...when classes are compiled they occupy a certain amount of memory...static variables of that class are a part of that memory...vs instance variables of classes occupy memory when objects are created of those classes ie at runtime...
    
    static let shared = NetworkingManager() //shared will be reference to the only object that will be created for this class...hence shared is a reference to the singleton object of this class...we have made this class as a singleton class by making the initializer of the class private...
    
    // Making the init of this class as private will ensure that no one from outside this class can initialize it...
    let baseUrl = "http://www.getnimnim.us:3000/"
    
    
    private init() {}
    
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
            let json = JSON(response.result.value)
            print("Response:\(String(describing: json))")
           // print("JSON Response:\(JSON(response.result.value))")
            if statusCode >= 200 && statusCode < 400 {                success?(response.result.value) // call of closure
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
                    }else if let error = responseValue["error"] as? [String:Any] {
                        if let message = error["message"] as? String {
                            failure?(message) // call of closure
                        }
                    }
                }
            }
        }
    }
    
    func put(withEndpoint endpoint:String?,withParams params:[String:Any]?, withSuccess success:((Any?)->Void)?, withFailure failure:((Any?) -> Void)?) {
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
        } // to tell the user
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers : headers ).responseJSON {
            response in
            guard let statusCode = response.response?.statusCode else {
                failure?(nil)
                return
            }
            print("Request:\(String(describing: response.request ?? nil))")
            print("Response:\(String(describing: response.result.value ?? nil))")
            
            if statusCode >= 200 && statusCode < 400 {
                print("success")
                print(JSON(response.result.value))
                success?(response.result.value) // call of closure
            }else {
                print("error")
                if let responseValue = response.result.value as? [String:Any] {
                    if let error = responseValue["error"] as? String {
                        failure?(error) // call of closure
                    }else if let error = responseValue["error"] as? [String:Any] {
                        if let message = error["message"] as? String {
                            failure?(message) // call of closure
                        }
                    }
                }
            }
        }
    }
    func delete(withEndpoint endpoint:String?,withParams params:[String:Any]?, withSuccess success:((Any?)->Void)?, withFailure failure:((Any?) -> Void)?) {
        guard let endpoint = endpoint else {
            return
        }
        guard let url = URL(string: baseUrl + endpoint) else {
            return
        }
        var headers : HTTPHeaders = [:]
        if let userModel = UserModel.fetchFromUserDefaults(){
            if let token = userModel.token{
                let finaltoken = token
                headers = ["Authorization":"Bearer \(finaltoken)"]
            }
        }
        Alamofire.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers : headers ).responseJSON {
            response in
            guard let statusCode = response.response?.statusCode else {
                failure?(nil)
                return
            }
            print("Request:\(String(describing: response.request ?? nil))")
            print("Response:\(String(describing: response.result.value ?? nil))")
            
            if statusCode >= 200 && statusCode < 400 {
                print("success")
                print(JSON(response.result.value))
                success?(response.result.value) // call of closure
            }else {
                print("error")
                if let responseValue = response.result.value as? [String:Any] {
                    if let error = responseValue["error"] as? String {
                        failure?(error) // call of closure
                    }else if let error = responseValue["error"] as? [String:Any] {
                        if let message = error["message"] as? String {
                            failure?(message) // call of closure
                        }
                    }
                }
            }
        }
    }
    
    func upload(withEndpoint endpoint:String?, withModel model:UploadModel?, withSuccess success:((Any?)->Void)?, withProgress uploadingProgress:((Progress?) -> Void)?, withFailure failure:((Any?) -> Void)?) {
        guard let endpoint = endpoint, let model = model else{
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
        guard let url = URL(string: baseUrl + endpoint) else {
            return
        }
        
    

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            self.append(fileData: model, toMultipartFormData: multipartFormData)
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    //print("Succesfully uploaded")
                    if let err = response.error{
                        failure?(err)
                        return
                    }
                    success?(response.result.value)
                }
                upload.uploadProgress { progress in
                    // print(progress.fractionCompleted)
                    uploadingProgress?(progress)
                }
            case .failure(let error):
                //print("Error in upload: \(error.localizedDescription)")
                failure?(error)
            }
        }
    }
    
    private func append(fileData data:UploadModel, toMultipartFormData multipartFormData:MultipartFormData) {
        if let fileData = data.data, let name = data.name, let fileName = data.fileName, let mimeType = data.mimeType {
            multipartFormData.append(fileData, withName: name, fileName: fileName, mimeType: mimeType.rawValue)
        }
    }
    
    //  are  we using the below: 
    func dictToJSON(dict:[String: Any]) -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
            if let decoded = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
                if let text = String(data: jsonData, encoding: .utf8) {
                    let test = String(text.filter { !" \n\t\r".contains($0) })
                    let finalString = test.replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "\\", with: "")
                    return finalString
                }
            }
        }
        return nil
    }
    
    func arrayToJSON(array:[String]) -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted) {
            if let decoded = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
                
                if let text = String(data: jsonData, encoding: .utf8) {
                    let test = String(text.filter { !" \n\t\r".contains($0) })
                    let finalString = test.replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "\\", with: "")
                    return finalString
                }
                
            }
        }
        return nil
    }
}


//please explain the use



