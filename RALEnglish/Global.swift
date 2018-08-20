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
let THEME_COLOR = UIColor.purple
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
        NVActivityIndicatorView.DEFAULT_TEXT_COLOR = THEME_COLOR
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
    
    func sendAlertWithHandler(alertTitle: String, alertMessage: String, actionTitle: [String], handlers:[(_ action: UIAlertAction) -> Void]) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        for i in 0..<actionTitle.count {
            alert.addAction(UIAlertAction(title: actionTitle[i], style: .default, handler: handlers[i]))
        }
        self.present(alert, animated: true, completion: nil)
    }
}
