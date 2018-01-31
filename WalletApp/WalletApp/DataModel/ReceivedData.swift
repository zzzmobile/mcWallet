//
//  DataStream.swift
//  WalletApp
//
//  Created by WangYing on 19/01/2018.
//  Copyright © 2018 MC. All rights reserved.
//

import UIKit

class ReceivedData : NSObject {
    public var id: String?
    public var receiverId: String?
    public var senderId: String?
    public var chainId: String?
    public var stream: String?
    public var txId: String?
    public var key: String?
    
    init(jsonDic: NSDictionary) {
        self.id = jsonDic["id"] != nil ? (jsonDic["id"] as! String) : nil
        self.receiverId = jsonDic["receiver_id"] != nil ? (jsonDic["receiver_id"] as! String) : nil
        self.senderId = jsonDic["sender_id"] != nil ? (jsonDic["sender_id"] as! String) : nil
        self.chainId = jsonDic["chain_id"] != nil ? (jsonDic["chain_id"] as! String) : nil
        self.stream = jsonDic["stream"] != nil ? (jsonDic["stream"] as! String) : nil
        self.txId = jsonDic["tx_id"] != nil ? (jsonDic["tx_id"] as! String) : nil
        self.key = jsonDic["key"] != nil ? (jsonDic["key"] as! String) : nil
    }
}

