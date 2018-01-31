//
//  ContentViewController.swift
//  WalletApp
//
//  Created by WangYing on 26/01/2018.
//  Copyright © 2018 MC. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func onViewStream(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "viewVC")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onPublishStream(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "publishVC")
        self.present(vc, animated: true, completion: nil)
    }
}
