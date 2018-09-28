//
//  DataService.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-18.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    //DB references
    private var _REF_BASE = DB_BASE
    private var _REF_STORY = DB_BASE.child("Story")
    private var _REF_MUSIC = DB_BASE.child("Music")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_STORY: DatabaseReference {
        return _REF_STORY
    }
    
    var REF_MUSIC: DatabaseReference {
        return _REF_MUSIC
    }
}
