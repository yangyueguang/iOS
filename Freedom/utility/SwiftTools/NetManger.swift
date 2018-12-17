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
    static let shared = NetManger()
    let serverTrustPolicies: [String: ServerTrustPolicy] = [
        "test.example.com": .pinCertificates(
            certificates: ServerTrustPolicy.certificates(),
            validateCertificateChain: true,
            validateHost: true
        ),
        "insecure.expired-apis.com": ServerTrustPolicy.disableEvaluation
    ]
    lazy var manager: SessionManager = {
        return SessionManager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: self.serverTrustPolicies))
    }()
    @discardableResult
    public func requestPolicy(_ url: URLConvertible,
                        parameters: Parameters?,
                        method: HTTPMethod = .get ,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders = [:], completion:@escaping (APIResponse) -> Void) -> DataRequest{
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let baseRequest = manager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        baseRequest.responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let res = APIResponse(request: baseRequest.request, response: nil, data: nil, error: response.result.error, dictionary: response.result.value as? [String: Any])
            completion(res)
        }
        return baseRequest
    }

    @discardableResult
    public func request(_ url: URLConvertible,
                        parameters: Parameters?,
                        method: HTTPMethod = .get ,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders = [:], completion:@escaping (APIResponse) -> Void) -> DataRequest{
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let baseRequest = Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        baseRequest.responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let res = APIResponse(request: baseRequest.request, response: nil, data: nil, error: response.result.error, dictionary: response.result.value as? [String: Any])
            completion(res)
        }
        return baseRequest
    }
}
