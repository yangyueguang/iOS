//
//  NetManger.swift
//  Freedom
//
//  Created by Super on 2018/7/23.
//  Copyright © 2018年 薛超. All rights reserved.
//

import UIKit
import Alamofire
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
}
