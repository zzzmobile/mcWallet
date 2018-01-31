//
//  ViewController.swift
//  WalletApp
//
//  Created by WangYing on 19/12/2017.
//  Copyright © 2017 MC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftQRScanner

class ViewController: UIViewController {

    @IBOutlet weak var txtNodeUrl: UITextField!
    @IBOutlet weak var txtPrivateKey: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    var nQRCode: Int!
    
    private let api  = WalletApi.sharedApi
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nQRCode = 0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        txtNodeUrl.text = "http://54.165.141.85:4200"
        txtPrivateKey.text = "4bf2db9d0249fd276b5e2da1c53682fb"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func txtNodeQRCodeDidChanged(_ sender: Any) {
        setLoginButtonState()
    }
    
    @IBAction func txtKeyQRCodeDidChanged(_ sender: Any) {
        setLoginButtonState()
    }
    
    
    @IBAction func onClickNodeQRCode(_ sender: Any) {
        nQRCode = 0
        scanQRCode()
    }
    
    @IBAction func onClickKeyQRCode(_ sender: Any) {
        nQRCode = 1
        scanQRCode()
    }

    @IBAction func onLogin(_ sender: Any) {
        Utils.showIndicator(view:view)
        api.login(baseUrl: txtNodeUrl.text!, privateKey: txtPrivateKey.text!, completion: { isSuccess, error in
            Utils.hideIndicator()
            
            if isSuccess {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "contentVC")
                self.present(vc, animated: true, completion: nil)
            }
        })
    }
    
    // methods
    func scanQRCode() {
        let scanner = QRCodeScannerController(cameraImage: UIImage(named: "camera"), cancelImage: UIImage(named: "cancel"), flashOnImage: UIImage(named: "flash-on"), flashOffImage: UIImage(named: "flash-off"))
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
   
    func setLoginButtonState() {
        if (txtNodeUrl.text?.isEmpty)! || (txtPrivateKey.text?.isEmpty)! {
            btnLogin.isEnabled = false
        } else {
            btnLogin.isEnabled = true
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        if nQRCode == 0 {
            txtNodeUrl.text = result;
        } else {
            txtPrivateKey.text = result;
        }
        
        setLoginButtonState()
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
}

