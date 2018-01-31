//
//  Utils.swift
//  WalletApp
//
//  Created by WangYing on 25/01/2018.
//  Copyright © 2018 MC. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Utils {
    private static var overlayView: UIView? = nil
    private static var activityIndicator: NVActivityIndicatorView? = nil

    public static func showIndicator(view: UIView) {
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let indRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let color = UIColor(red: 217 / 255.0, green: 83 / 255.0, blue: 79 / 255.0, alpha: 1)
        activityIndicator = NVActivityIndicatorView(frame: indRect, type: NVActivityIndicatorType.cubeTransition, color: color, padding: 20)
        activityIndicator?.center = (overlayView?.center)!
        overlayView?.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
        view.addSubview(overlayView!)
    }
    
    public static func hideIndicator() {
        activityIndicator?.stopAnimating()
        overlayView?.removeFromSuperview()
    }
    
    public static func trim(_ string: String, trimChar: String) -> String {
        var ret = ""
        for c in string {
            if trimChar != String(c) {
                ret.append(c)
            }
        }
        return ret
    }
    
}
