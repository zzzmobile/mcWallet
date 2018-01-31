//
//  ChainData.swift
//  WalletApp
//
//  Created by WangYing on 25/01/2018.
//  Copyright © 2018 MC. All rights reserved.
//

import UIKit

class ChainData : NSObject {
    public var ip: String?
    public var port: String?
    public var chainName: String?
    public var address: String?
    public var grant: String?
    public var id: Int64?

    init(jsonDic: NSDictionary) {
        self.ip = jsonDic["ip"] != nil ? (jsonDic["ip"] as! String) : nil
        self.port = jsonDic["port"] != nil ? (jsonDic["port"] as! String) : nil
        self.chainName = jsonDic["chain_name"] != nil ? (jsonDic["chain_name"] as! String) : nil
        self.address = jsonDic["address"] != nil ? (jsonDic["address"] as! String) : nil
        self.grant = jsonDic["grant"] != nil ? (jsonDic["grant"] as! String) : nil
        self.id = jsonDic["id"] != nil ? (jsonDic["id"] as! Int64) : 0
    }
}
