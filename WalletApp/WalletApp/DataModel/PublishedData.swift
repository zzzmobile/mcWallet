//
//  PublishedData.swift
//  WalletApp
//
//  Created by WangYing on 27/01/2018.
//  Copyright © 2018 MC. All rights reserved.
//

import UIKit

class PublishedData : NSObject {
    public var id: Int64?
    public var userId: String?
    public var chainId: String?
    public var stream: String?
    public var key: String?
    public var txId: String?
    
    init(jsonDic: NSDictionary) {
        self.id = jsonDic["id"] != nil ? (jsonDic["id"] as! Int64) : nil
        self.userId = jsonDic["user_id"] != nil ? (jsonDic["user_id"] as! String) : nil
        self.chainId = jsonDic["chain_id"] != nil ? (jsonDic["chain_id"] as! String) : nil
        self.stream = jsonDic["stream"] != nil ? (jsonDic["stream"] as! String) : nil
        self.key = jsonDic["key"] != nil ? (jsonDic["key"] as! String) : nil
        self.txId = jsonDic["tx_id"] != nil ? (jsonDic["tx_id"] as! String) : nil
    }
}
