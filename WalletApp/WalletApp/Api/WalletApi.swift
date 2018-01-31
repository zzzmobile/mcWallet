//
//  WalletApi.swift
//  WalletApp
//
//  Created by WangYing on 18/01/2018.
//  Copyright © 2018 MC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class WalletApi {
    
    static let sharedApi = WalletApi()
    
    public static var userName: String? = nil
    public static var userId: String? = nil
    public static var userRole: String? = nil
    
    /// Authorization token for passing to server requests.
    private var authToken: String?      = nil
    
    private var baseURL: String?//        = "http://54.165.141.85:4200"
    
    
    func login(baseUrl: String, privateKey: String, completion: @escaping ((_ isSuccess: Bool, _ error: Error?) -> Void)) {
        baseURL = baseUrl
        let url = baseURL! + "/mc/authenticate"
        let parameters: [String: String] = ["privateKey": privateKey]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if response.result.value != nil {
                var error       = response.result.error
                var isSuccess   = response.result.isSuccess
                
                let swiftyJsonVar = JSON(response.result.value as Any)
                WalletApi.userName = swiftyJsonVar["name"].stringValue
                WalletApi.userRole = swiftyJsonVar["role"].stringValue
                WalletApi.userId = swiftyJsonVar["id"].stringValue

                defer {
                    completion(isSuccess, error)
                }
            }
        }
    }

    func getReceivedDataList(userid: String, completion: @escaping (_ list:[ReceivedData]) -> Void) {
        let url = baseURL! + "/mc/get-received-data-list"
        let parameters: [String: String] = ["id": userid]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if response.result.value != nil {
                var streamArray = [ReceivedData]()
                if let objJson = response.result.value as! NSArray? {
                    for element in objJson {
                        let data = element as! NSDictionary
                        let model = ReceivedData(jsonDic: data)
                        streamArray.append(model)
                    }
                    completion(streamArray)
                }
            }
        }
    }
    
    func getPublishedDataList(userid: String, completion: @escaping (_ list:[PublishedData]) -> Void) {
        let url = baseURL! + "/mc/get-published-data-list"
        let parameters: [String: String] = ["id": userid]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if response.result.value != nil {
                var streamArray = [PublishedData]()
                if let objJson = response.result.value as! NSArray? {
                    for element in objJson {
                        let data = element as! NSDictionary
                        let model = PublishedData(jsonDic: data)
                        streamArray.append(model)
                    }
                }
                completion(streamArray)
            } else {
                completion([PublishedData]())
            }
        }
    }

    func getChainList(userId: String, completion:@escaping (_ list:[ChainData]) -> Void) {
        let url = baseURL! + "/mc/get-chain-list"
        let parameters: [String: String] = ["id": userId]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if response.result.value != nil {
                var chainArray = [ChainData]()
                if let objJson = response.result.value as! NSArray? {
                    for element in objJson {
                        let data = element as! NSDictionary
                        let model = ChainData(jsonDic: data)
                        chainArray.append(model)
                    }
                    completion(chainArray)
                }
            } else {
                completion([ChainData]())
            }
        }
    }

    func viewStream(id: String, stream: String, txid: String, completion: @escaping (_ data: String, _ isFile: Bool) -> Void) {
        let url = baseURL! + "/mc/view-stream"
        let parameters: [String: String] = ["id": id, "stream": stream, "txid": txid]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil {
                        let swiftyJsonVar = JSON(response.result.value as Any)
                        let data = swiftyJsonVar["data"].stringValue
                        if !data.isEmpty {
                            completion(data, false)
                        }
                    }
                case .failure(_):
                    completion("", false)
                    break;
                }
            }
            .responseString { response in
                switch(response.result) {
                case .success(_):
                    completion(response.result.value!, true)
                case .failure(_):
                    completion("", true)
                    break;
                }
            }
    }

    func publishStream(id: Int64, stream: String, key: String, data: String, completion: @escaping (_ txId: String) -> Void) {
        let url = baseURL! + "/mc/publish-stream"
        let parameters: [String: AnyObject] = [
            "id": id as AnyObject,
            "stream": stream as AnyObject,
            "key": key as AnyObject,
            "data": data as AnyObject]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil {
                    let swiftyJsonVar = JSON(response.result.value as Any)
                    let txId = swiftyJsonVar["txid"].stringValue
                    completion(txId)
                } else {
                    completion("Empty")
                }
            case .failure(_):
                completion("Error")
                break;
            }
        }
    }
}
