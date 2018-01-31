//
//  PublishStreamViewController.swift
//  WalletApp
//
//  Created by WangYing on 22/01/2018.
//  Copyright © 2018 MC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SandboxBrowser

class PublishStreamViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var txtChainIP: UITextField!
    @IBOutlet weak var txtStream: UITextField!
    @IBOutlet weak var txtKey: UITextField!
    @IBOutlet weak var txtContent: UITextView!
    var streamData = [ChainData]()
    private let api  = WalletApi.sharedApi
    
    var alertView: UIAlertController? = nil
    var currentIndex: Int? = 0
    
    var fileBrowser: SandboxBrowser!
    var uploadPath: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadChainList()
        makeAlertController()
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = paths[0]
        fileBrowser = SandboxBrowser(initialPath: docDirectory)
        fileBrowser.didSelectFile = { file, vc in
            self.fileBrowser.dismiss(animated: true, completion: nil)
            self.uploadPath = file.path
            self.txtContent.text = self.readFile(filepath: file.path)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadChainList() {
        Utils.showIndicator(view: view)
        api.getChainList(userId: WalletApi.userId!) { (chainData: [ChainData]) in
            self.streamData = chainData
            self.initStreamList()
            Utils.hideIndicator()
        }
    }
    
    func makeAlertController() {
        alertView = UIAlertController(
            title: "Select Chain",
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .alert
        )
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 40, width: 250, height: 100))
        pickerView.dataSource = self
        pickerView.delegate = self
        alertView?.view.addSubview(pickerView)

        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertView?.addAction(action)
    }
    
    func initStreamList() {
        if streamData.count > 0 {
            self.txtChainIP.text = streamData[0].ip! + ":" + streamData[0].chainName!
        }
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSelectStream(_ sender: Any) {
        present(alertView!, animated: true, completion: nil)
    }
    
    @IBAction func onUpload(_ sender: Any) {
        present(fileBrowser, animated: true, completion: nil)
    }
    
    @IBAction func onPublish(_ sender: Any) {
        if (txtChainIP.text?.isEmpty)! || (txtStream.text?.isEmpty)! || (txtKey.text?.isEmpty)! {
            showAlert()
            return
        }
        
        if (txtContent.text?.isEmpty)! {
            showAlert()
            return
        }
        
        Utils.showIndicator(view: view)
        let id = streamData[currentIndex!].id!
        
        api.publishStream(id: id, stream: txtStream.text!, key: txtKey.text!, data: txtContent.text!) { (string: String) in
            self.txtContent.text = ""
            self.txtKey.text = ""
            self.txtStream.text = "";
            Utils.hideIndicator()
            
            let alert = UIAlertController(title: "", message: string, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return streamData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return streamData[component].ip! + ":" + streamData[component].chainName!
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "", message: "Please fill empty fields", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func readFile(filepath: String) -> String {
        let filename = (filepath as NSString).lastPathComponent
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let url = dir?.appendingPathComponent(filename)
        var string: String = ""
        
        do {
            string = try String(contentsOf: url!, encoding: String.Encoding.ascii)
        } catch {}

        return filename + "<,,>" + string
    }
}
