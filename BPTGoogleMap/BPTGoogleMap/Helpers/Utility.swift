//
//  Utility.swift
//  BPTLogin
//
//  Created by Basith on 23/04/20.
//  Copyright © 2020 Agaze. All rights reserved.
//
/*
 ** jsonDomObject abstracts GET requests to various endpoints and translating
 ** the JSON data to appropriate data sructures. "getDataFromCloud()" method makes the
 ** request to get the JSON. subsequent calls can be made to get data and count

 ** of the JSON data received.

 ** Request for data is to be passed from right to left to identify the key / value node

 ** RootNode, Index, Key will featch the value of [rootnode][index][key].value

 */

import Foundation
import Alamofire
import SwiftyJSON

public class jsonDomObject {
    private var m_gotData:Bool
    private var m_url: String
    private let m_BaseUrl: String
    private var m_swiftyJsonVar : JSON

    init(reqUrl : String){
        m_gotData = false
        m_url = reqUrl
        m_BaseUrl = ""
        m_swiftyJsonVar = JSON.null
    }

    init(){
        m_gotData = false
        m_url = ""
        m_BaseUrl = ""
        m_swiftyJsonVar = JSON.null
    }

    func getDataFromCloud(callBack: @escaping (Bool)->Void) -> Void {
        assert(!m_url.isEmpty,"getDataFromCloud URL null")
        Alamofire.request(self.m_url).responseJSON { (responseData) -> Void in
//            print("GETDC",responseData)
            switch responseData.result {
            case .success:
                if((responseData.result.value) != nil) {
                    self.m_swiftyJsonVar = JSON(responseData.result.value!)
                    callBack(true)
                }else {
                    callBack(false)
                }
            case .failure(let error):
                // assertionFailure("request failed")
                callBack(false)
            }
        }
    }

    func getDataFromCloud(endPointUrl:String, callBack: @escaping (Bool)->Void) -> Void {
        assert(!m_url.isEmpty,"getDataFromCloud URL null")
        Alamofire.request(endPointUrl).responseJSON { (responseData) -> Void in
            switch responseData.result {
            case .success:
                if((responseData.result.value) != nil) {
                    self.m_swiftyJsonVar = JSON(responseData.result.value!)
                    callBack(true)
                }else {
                    callBack(false)
                }
            case .failure(let error):
                // assertionFailure("request failed")
                callBack(false)
            }
        }
    }
    func getDataFromCloud(reqUrl:String, callBack: @escaping (JSON?, NSError?)->Void) -> Void {
        assert(!m_url.isEmpty,"getDataFromCloud URL null")
        Alamofire.request(reqUrl).responseJSON { (responseData) -> Void in
            print("get request")
            switch responseData.result {
            case .success:
                if((responseData.result.value) != nil) {
                    self.m_swiftyJsonVar = JSON(responseData.result.value!)
                    callBack(JSON(responseData.result.value!), nil)
                }else {
                    // callBack()

                }
            case .failure(let error):
                callBack(nil,error as NSError)
                print("get request fail")
            }
        }
    }
    private func getString(rootKey: String)->String {
        return self.m_swiftyJsonVar[rootKey].stringValue
    }
    
    private func getString(rootKey: String, secondKey: String)->String {
        return self.m_swiftyJsonVar[rootKey][secondKey].stringValue
    }
    
    func getString(rootKey: String, index: Int, leafKey: String)->String {
        return self.m_swiftyJsonVar[rootKey][index][leafKey].stringValue
    }
    
    private func getString(rootKey: String, secondKey: String, thirdKey: String)->String {
        return self.m_swiftyJsonVar[rootKey][secondKey][thirdKey].stringValue
    }

    
    func getAsDictionaryKeys() -> [String]{
        var myKeyArray = [String]()
        for value in (self.m_swiftyJsonVar.dictionary?.keys)! {
            myKeyArray.append(value)
        }
        return myKeyArray
    }
    func getAsDictionaryValues() -> [String]{
        var myKeyArray = [String]()
        for value in (self.m_swiftyJsonVar.dictionary?.values)! {
            myKeyArray.append(value.string!)
        }
        return myKeyArray
    }

    // used to count dates from server

    func getNumElementsDictionary() -> Int {
        var myKeyArray = [String]()
        for value in (self.m_swiftyJsonVar.dictionary?.keys)! {
            myKeyArray.append(value)
        }
        return myKeyArray.count
    }
    func getAsDictionaryKeys() -> [String:Any]{
        return self.m_swiftyJsonVar.dictionary!
    }
    
    func getAsDictionaryKeys() -> [String:String]{
        var newDict = [String:String]()
        let myDict = self.m_swiftyJsonVar.dictionary!
        for myString in myDict {
            let myValue = myString.value.description // jsonToString(json: myString.value)
            newDict.updateValue(myValue, forKey: myString.key)
        }
        return newDict
    }

    private func jsonToString(json: AnyObject) -> String {
        var convertedString = ""
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            convertedString = String(data: data1, encoding: String.Encoding.utf8) ?? "" // the data will be converted to the string
            // print(convertedString ?? "defaultvalue")

        } catch let myJSONError {
            print(myJSONError)
        }
        return convertedString
    }
    
    func getString(rootKey: String, index: Int, secondKey: String, thirdKey: String)->String {
        return self.m_swiftyJsonVar[rootKey][index][secondKey][thirdKey].stringValue
    }
    
    func getString(rootKey: String, index: Int, secondKey: String, thirdKey: String, fourthKey: String)->String {
        return self.m_swiftyJsonVar[rootKey][index][secondKey][thirdKey][fourthKey].stringValue
    }
    
    private func getString(rootKey: String, index: Int, secondKey: String, thirdKey: String, fourthKey: String, fifthKey: String, sixthKey: String)->String {
        return self.m_swiftyJsonVar[rootKey][index][secondKey][thirdKey][fourthKey][fifthKey][sixthKey].stringValue
    }
    
    private func getStringFromArray(rootKey: String, index: Int)->String? {
        if (self.m_swiftyJsonVar[rootKey].arrayValue.count > index){
            return self.m_swiftyJsonVar[rootKey][index].stringValue
        }else {
            return nil
        }
    }
    
    func getStringFromArray(rootKey: String, index: Int, leafKey: String)->String? {
        return self.m_swiftyJsonVar[rootKey][index][leafKey].stringValue
    }

    func getNumElements(rootKey:String) -> Int {
        return (self.m_swiftyJsonVar[rootKey].arrayValue.count)
    }

    private func getStringFromArray(rootKey: String, secondKey: String, index: Int)->String {
        return self.m_swiftyJsonVar[rootKey][index][secondKey].stringValue
    }

    private func getStringFromArray(rootKey: String, secondKey: String, thirdKey: String, index: Int)->String {
        return (self.m_swiftyJsonVar[rootKey][secondKey][thirdKey].arrayValue[index]).stringValue
    }

    private func getIntFromArray(rootKey: String, index: Int)->Int {
        return (self.m_swiftyJsonVar[rootKey].arrayValue[index]).intValue
    }

    private func getIntFromArray(rootKey: String, secondKey: String, index: Int)->Int {
        return (self.m_swiftyJsonVar[rootKey][secondKey].arrayValue[index]).intValue
    }
    
    private func getStringFromArray(rootKey: String, secondKey: String, thirdKey: String, index: Int)->Int {
        return (self.m_swiftyJsonVar[rootKey][secondKey][thirdKey].arrayValue[index]).intValue
    }

    private func getStringArray(rootKey: String)->[String] {
        var retArray = [String]()
        for (jsonVal) in (self.m_swiftyJsonVar[rootKey].arrayValue){
            retArray.append(jsonVal.stringValue)
        }
        return retArray
    }

    private func getStringArray(rootKey: String, secondKey: String)->[String] {
        var retArray = [String]()
        for (jsonVal) in (self.m_swiftyJsonVar[rootKey][secondKey].arrayValue){
            retArray.append(jsonVal.stringValue)
        }
        return retArray
    }
    
    private func getNStringArray(rootKey: String, secondKey: String, thirdKey: String)->[String] {
        var retArray = [String]()
        for (jsonVal) in (self.m_swiftyJsonVar[rootKey][secondKey][thirdKey].arrayValue){
            retArray.append(jsonVal.stringValue)
        }
        return retArray
    }
    
    private func getInt(rootKey: String)->Int {
        return self.m_swiftyJsonVar[rootKey].intValue
    }
    
    private func getInt(rootKey: String, secondKey: String)-> Int {
        return self.m_swiftyJsonVar[rootKey][secondKey].intValue
    }
    
    func getInt(rootKey: String, index: Int, secondKey: String)-> Int {
        return self.m_swiftyJsonVar[rootKey][index][secondKey].intValue
    }
    
    func getInt(rootKey: String, index: Int, secondKey: String, thirdKey: String)->Int
    {
        return self.m_swiftyJsonVar[rootKey][index][secondKey][thirdKey].intValue
    }
    
    private func getInt(rootKey: String, secondKey: String, thirdKey: String)->Int {
        return self.m_swiftyJsonVar[rootKey][secondKey][thirdKey].intValue
    }

    private func getBool (rootKey: String, secondKey: String, thirdKey: String)->Bool {
        return self.m_swiftyJsonVar[rootKey][secondKey][thirdKey].boolValue
    }

    func getBool (rootKey: String, index: Int, secondKey: String)->Bool {
        return self.m_swiftyJsonVar[rootKey][index][secondKey].boolValue
    }
    
    func sendPostDataToCloud(serviceName:String, parameters: [String:Any]?, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        let params: Parameters = parameters!
        Alamofire.request(serviceName, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON {
                            (response:DataResponse<Any>) in
                            switch(response.result) {
                            case .success(_):
                                if let data = response.result.value {
                                    let json = JSON(data)
                                    completionHandler(json, nil)
                                }
                                break
                            case .failure(_):
                                completionHandler(nil, response.result.error as NSError?)
                                break
                            }
        }
    }
    func sendDeleteReqToCloud(serviceName:String, completionHandler: @escaping (JSON?, NSError?) -> ()) {
        Alamofire.request(serviceName, method: .delete, parameters: nil, encoding: JSONEncoding.default).responseJSON {
                            (response:DataResponse<Any>) in
                            switch(response.result) {
                            case .success(_):
                                if let data = response.result.value{
                                    let json = JSON(data)
                                    completionHandler(json,nil)
                                }
                                break
                            case .failure(_):
                                completionHandler(nil,response.result.error as NSError?)
                                break
                            }
        }
    }
    
    func gotoView(identifier: String){

    }


    func uploadData(url : String,parameters: [String:Any],data: Data?,filename: String,uploadType: UPLOAD_DATA_TYPES, completionHandler: @escaping (JSON?, NSError?) -> ()){
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        //let parameters = parameters
        Alamofire.upload(multipartFormData: { (postData) in
            for (key, value) in parameters {
                postData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = data{
                postData.append(data, withName: "file", fileName: filename, mimeType: "image/jpg")
            }
            print(" MultipartFormData:::::: ")
            print(postData)
        }, to: url, method: .post, headers: headers)
        {
            (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Response ", response)
                }
            case .failure(let encodingError):
                print("Error ", encodingError)
            }
        }
    }

    func uploadData(url : String,parameters: [String:Any], completionHandler: @escaping (JSON?, NSError?) -> ()){
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        //let parameters = parameters
        Alamofire.upload(multipartFormData: { (postData) in
            for (key, value) in parameters {
                postData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            print(" MultipartFormData:::::: ")
            print(postData)
        }, to: url, method: .post, headers: headers)
        {
            (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Response ", response)
                }
            case .failure(let encodingError):
                print("Error ", encodingError)
            }
        }
    }
    
}

public enum UPLOAD_DATA_TYPES: String {
    case PNG = "image/png"
    case JPG = "image/jpeg"
}


public enum APP_ENDPOINT_URL : String {
    case baseUrl                    = "https://cure4life-dev-100.appspot.com"
    case appId                      = "/?app_id=77b4cdc8ad1bb76c06a2"
    case loginRequest               = "/auth/service/v1/user/login"
    case forgoPasswordtRequest      = "..."
    case changePasswordRequest      = ".."
}

class AppUrl {
    func getUrl(endPoint : APP_ENDPOINT_URL)->String {
        return APP_ENDPOINT_URL.baseUrl.rawValue+endPoint.rawValue +  APP_ENDPOINT_URL.appId.rawValue
    }
    func getUrl(endPoint: APP_ENDPOINT_URL,filter: String)->String{
        return APP_ENDPOINT_URL.baseUrl.rawValue+endPoint.rawValue+filter
    }
    func getUrl(endPoint: APP_ENDPOINT_URL, filter: APP_ENDPOINT_URL, filterVal : String)->String{
        return APP_ENDPOINT_URL.baseUrl.rawValue + endPoint.rawValue +
            APP_ENDPOINT_URL.appId.rawValue + filter.rawValue + filterVal
    }
    func getUrl(endPoint: APP_ENDPOINT_URL, filter_1: APP_ENDPOINT_URL, filterVal_1 : String, filter_2: APP_ENDPOINT_URL, filterVal_2 : String)->String {
        let myUrl = APP_ENDPOINT_URL.baseUrl.rawValue + endPoint.rawValue + APP_ENDPOINT_URL.appId.rawValue
        let filter = filter_1.rawValue + filterVal_1 + filter_2.rawValue + filterVal_2
        return myUrl + filter
    }
    func getUrl(endPoint: APP_ENDPOINT_URL, filter_1: APP_ENDPOINT_URL, filterVal_1 : String,
                filter_2: APP_ENDPOINT_URL, filterVal_2 : String, filter_3: APP_ENDPOINT_URL, filterVal_3 : String)->String{
        let myUrl = self.getUrl(endPoint: APP_ENDPOINT_URL(rawValue: endPoint.rawValue)!,  filter_1: filter_1,  filterVal_1: filterVal_1,  filter_2: filter_2,  filterVal_2: filterVal_2)
        let filter = filter_3.rawValue + filterVal_3
        return myUrl + filter
    }
 
    func getUrl(endPoint: APP_ENDPOINT_URL,filetrVal:String)->String{
        let myUrl = APP_ENDPOINT_URL.baseUrl.rawValue+endPoint.rawValue+filetrVal+APP_ENDPOINT_URL.appId.rawValue
        return myUrl
    }
    func getUrl(endPoint: APP_ENDPOINT_URL, filter_1: APP_ENDPOINT_URL, filterVal_1 : String,
                filter_2: APP_ENDPOINT_URL, filterVal_2 : String, filter_3: APP_ENDPOINT_URL, filterVal_3 : String, filter_4: APP_ENDPOINT_URL, filterVal_4 : String)->String{
        let myUrl = self.getUrl(endPoint: APP_ENDPOINT_URL(rawValue: endPoint.rawValue)!,  filter_1: filter_1,  filterVal_1: filterVal_1,  filter_2: filter_2,  filterVal_2: filterVal_2)
        let filter = filter_3.rawValue + filterVal_3 + filter_4.rawValue + filterVal_4
        return myUrl + filter
    }
 
    func getUrl(endPointValue: String)->String{
        let returnString = APP_ENDPOINT_URL.baseUrl.rawValue+endPointValue
        return returnString
    }
     
    func getUrl(endPoint: APP_ENDPOINT_URL, filterVal : String)->String{
        return APP_ENDPOINT_URL.baseUrl.rawValue + endPoint.rawValue + filterVal +
            APP_ENDPOINT_URL.appId.rawValue
    }
    

} /* AppUrl */

