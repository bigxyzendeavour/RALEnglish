
//
//  Content.swift
//  EnglishCollection
//
//  Created by Grandon Lin on 2018-08-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import AVFoundation

class StoryContent: Content {
    
//    private var _contentID: Int!
//    private var _title: String!
    private var _description: String!
    private var _author: String!
//    private var _contentURL: String!
    private var _contentData: Data!
    private var _lyric: String!
//    private var _contentDisplayURL: String!
    
    override init() {
        super.init()
    }
    
    override init(contentID: Int, contentData: Dictionary<String, Any>) {
        super.init(contentID: contentID, contentData: contentData)
//        self._contentID = contentID
        
//        if let contentTitle = contentData["Title"] as? String {
//            self._title = contentTitle
//        }
        
        if let contentDesc = contentData["Description"] as? String {
            self._description = contentDesc
        }
        
        if let contentAuthor = contentData["Author"] as? String {
            self._author = contentAuthor
        }
        
//        if let contentURL = contentData["URL"] as? String {
//            self._contentURL = contentURL
//        }
        
//        if let contentDisplayImageURL = contentData["Display URL"] as? String {
//            self._contentDisplayURL = contentDisplayImageURL
//        }
        
        if let contentLyric = contentData["Lyric"] as? String {
            self._lyric = contentLyric
        }
    }
    
    var author: String {
        get {
            if _author == nil {
                _author = ""
            }
            return _author
        }
        set {
            _author = newValue
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
    
    var lyric: String {
        get {
            if _lyric == nil {
                _lyric = ""
            }
            return _lyric
        }
        set {
            _lyric = newValue
        }
    }
}
