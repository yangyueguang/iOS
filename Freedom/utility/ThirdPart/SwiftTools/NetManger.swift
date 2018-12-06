//
//  NetManger.swift
//  Freedom
//
//  Created by Super on 2018/7/23.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class NetManger: NSObject {
    func searchAddress(withText text: String, location: String, radios radio: Float, resultBlock: @escaping (_ id :AnyObject?, _ error :Error?) -> Void) {
        let baseAPI = "https://www.aaa.place/textsearch/json"
        let parameters: Parameters = [
            "query" : text,
            "location" : location,
            "radius" : radio,
            "key" : ""
        ]
        let headers: HTTPHeaders = ["Authorization": "","Accept": "application/json"]
        Alamofire.request(baseAPI, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (result) in
            print(result)
        }
        let allapi = "https://www.aaa.place/textsearch/json?query=\(text)&location=\(location)&radius=\(radio)&key="
        Alamofire.request(allapi).responseJSON { (result) in
            print(result)
        }
    }
    class func getResponseData(_ url:String, parameters:[String:AnyObject]? = nil, success:@escaping(_ result:JSON)-> Void, error:@escaping (_ error:NSError)->Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url, parameters: parameters).responseJSON { (response) in
            if let jsonData = response.result.value {
                success(JSON(jsonData))
            } else if let er = response.result.error {
                error(er as NSError)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
