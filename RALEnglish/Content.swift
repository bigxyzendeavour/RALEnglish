
//
//  Content.swift
//  EnglishCollection
//
//  Created by Grandon Lin on 2018-08-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import AVFoundation

class Content {
    
    private var _contentID: String!
    private var _title: String!
    private var _description: String!
    private var _contentURL: String!
    private var _contentData: Data!
    
    init() {
        
    }
    
    init(contentID: String, contentData: Dictionary<String, Any>) {
        self._contentID = contentID
        if let contentTitle = contentData["Title"] as? String {
            self._title = contentTitle
        }
        
        if let contentDesc = contentData["Description"] as? String {
            self._description = contentDesc
        }
        
        if let contentURL = contentData["URL"] as? String {
            self._contentURL = contentURL
            do {
                self._contentData = try Data(contentsOf: URL(string: contentURL)!)
            } catch let err as NSError {
                print(err)
            }
            
        }
    }
    
    var contentID: String {
        get {
            if _contentID == nil {
                _contentID = ""
            }
            return _contentID
        }
        set {
            _contentID = newValue
        }
    }
    
    var title: String {
        get {
            if _title == nil {
                _title = ""
            }
            return _title
        }
        set {
            _title = newValue
        }
    }
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
            return _description
        }
        set {
            _description = newValue
        }
    }
    
    var contentURL: String {
        get {
            if _contentURL == nil {
                _contentURL = ""
            }
            return _contentURL
        }
        set {
            _contentURL = newValue
        }
    }
    
    var contentData: Data {
        get {
            if _contentData == nil {
                _contentData = Data()
            }
            return _contentData
        }
        set {
            _contentData = newValue
        }
    }
}
