//
//  Content.swift
//  RALEnglish
//
//  Created by Grandon Lin on 2018-08-28.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import Foundation

class Content {
    
    private var _contentID: Int!
    private var _title: String!
    private var _contentURL: String!
    private var _contentDisplayURL: String!
    private var _contentLength: Int!
    
    init() {
        
    }
    
    init(contentID: Int, contentData: Dictionary<String, Any>) {
        self._contentID = contentID
        
        if let contentTitle = contentData["Title"] as? String {
            self._title = contentTitle
        }
        
        if let contentURL = contentData["URL"] as? String {
            self._contentURL = contentURL
        }
        
        if let contentDisplayImageURL = contentData["Display URL"] as? String {
            self._contentDisplayURL = contentDisplayImageURL
        }
        
        if let contentLength = contentData["Total Time"] as? Int {
            self._contentLength = contentLength
        }
    }
    
    var contentID: Int {
        get {
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
    
    var contentDisplayURL: String {
        get {
            if _contentDisplayURL == nil {
                _contentDisplayURL = ""
            }
            return _contentDisplayURL
        }
        set {
            _contentDisplayURL = newValue
        }
    }
    
    var contentLength: Int {
        get {
            if _contentLength == nil {
                _contentLength = 0
            }
            return _contentLength
        }
        set {
            _contentLength = newValue
        }
    }
}
