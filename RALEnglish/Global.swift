//
//  Global.swift
//  EnglishCollection
//
//  Created by Grandon Lin on 2018-08-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

let activityData = ActivityData()
let THEME_COLOR = UIColor(red: 248.0/255.0, green: 255.0/255.0, blue: 244.0/255.0, alpha: 1.0)
var isRefreshing = false

extension UIView {
    
    func heightCircleView() {
        layer.cornerRadius = self.frame.height / 2.0
        clipsToBounds = true
    }
    
    func heightCircleView(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

extension UIViewController {
    func startRefreshing() {
        isRefreshing = true
        NVActivityIndicatorView.DEFAULT_COLOR = THEME_COLOR
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = "Loading"
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func endRefrenshing() {
        isRefreshing = false
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func sendAlertWithoutHandler(alertTitle: String, alertMessage: String, actionTitle: [String]) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        for action in actionTitle {
            alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
}
