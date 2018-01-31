//
//  ChainViewController.swift
//  WalletApp
//
//  Created by WangYing on 17/01/2018.
//  Copyright © 2018 MC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblStream: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    var streamData = [PublishedData]()
    let api  = WalletApi.sharedApi
    var currentIndex: Int = -1
    var currentFileName: String = ""
    var contentString: String = ""
    var isView: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tblStream.dataSource = self
        tblStream.delegate = self
        loadChainList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadChainList() {
        Utils.showIndicator(view: view)
        api.getPublishedDataList(userid: WalletApi.userId!) { (publishedData: [PublishedData]) in
            self.streamData = publishedData
            self.reload()
            Utils.hideIndicator()
        }
    }
    
    func reload() {
        if streamData.count > 0 {
            self.tblStream.isHidden = false
            self.lblNoData.isHidden = true
            self.tblStream.reloadData()
        } else {
            self.tblStream.isHidden = true
            self.lblNoData.isHidden = false
        }
    }

    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streamData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblStream.dequeueReusableCell(withIdentifier: "streamCell", for: indexPath) as! StreamTableViewCell
        let cellData = streamData[indexPath.row]
        cell.lblCellTitle.text = cellData.txId
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentIndex = indexPath.row
    }
    
    @IBAction func onSelectStream(_ sender: Any) {
        if currentIndex == -1 {
            return
        }
        
        isView = true
        let data = streamData[currentIndex]
        Utils.showIndicator(view: view)
        // String(describing: data.id)
        // data.txId!
        api.viewStream(id: "10", stream: data.stream!, txid: data.txId!) { (result: String, isFile: Bool) in
            
            if result.isEmpty {
                if self.isView {
                    let alert = UIAlertController(title: "Error", message: "Failed", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                self.isView = false
            } else {
                if isFile {
                    // file
                    if self.isView {
                        let strResponse = Utils.trim(result, trimChar: "\"")
                        var stringAry = strResponse.components(separatedBy: "<,,>")
                        self.currentFileName = stringAry[0]
                        self.contentString = stringAry[1]
                        let alert = UIAlertController(title: "Stream Information", message: self.currentFileName, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Download", style: UIAlertActionStyle.default, handler: { action in
                            if action.style == UIAlertActionStyle.default {
                                self.downloadFile()
                            }
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.isView = false
                } else {
                    // text
                    if self.isView {
                        let alert = UIAlertController(title: "Stream Information", message: result, preferredStyle: UIAlertControllerStyle.alert)
                        self.currentFileName = ""
                        self.contentString = result
                        alert.addAction(UIAlertAction(title: "Download", style: UIAlertActionStyle.default, handler: { action in
                            if action.style == UIAlertActionStyle.default {
                                self.downloadFile()
                            }
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.isView = false
                }
                
            }

            Utils.hideIndicator()
        }
    }
    
    func downloadFile() {
        if currentFileName.isEmpty {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd_hhmmss"
            let dateString = formatter.string(from: date)
            let fileName = "blockchain_" + dateString + ".txt"
            writeFile(filename: fileName, content: contentString)
        } else {
            writeFile(filename: self.currentFileName, content: contentString)
        }
    }
    
    func writeFile(filename: String, content: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = paths[0]
        let filepath = docDirectory.absoluteString + "/" + filename
        
        do {
            try content.write(to: NSURL(string: filepath)! as URL, atomically: false, encoding: String.Encoding.ascii)
        } catch {}
    }
}
