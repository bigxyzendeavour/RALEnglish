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
    private var _REF_24M = DB_BASE.child("0-24 Months")
    private var _REF_3Y = DB_BASE.child("2-3 Years")
    private var _REF_4Y = DB_BASE.child("3-4 Years")
    private var _REF_5Y = DB_BASE.child("4-5 Years")
    private var _REF_VOCABULARY = DB_BASE.child("Vocabulary")
    private var _REF_SOMETHING = DB_BASE.child("Something")
    
    //STORAGE references
    private var _STORAGE_24M = STORAGE_BASE.child("0-24 Months")
    private var _STORAGE_3Y = STORAGE_BASE.child("2-3 Years")
    private var _STORAGE_4Y = STORAGE_BASE.child("3-4 Years")
    private var _STORAGE_5Y = STORAGE_BASE.child("4-5 Years")
    private var _STORAGE_VOCABULARY = STORAGE_BASE.child("Vocabulary")
    private var _STORAGE_SOMETHING = STORAGE_BASE.child("Something")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_24M: DatabaseReference {
        return _REF_24M
    }
    
    var REF_3Y: DatabaseReference {
        return _REF_3Y
    }
    
    var REF_4Y: DatabaseReference {
        return _REF_4Y
    }
    
    var REF_5Y: DatabaseReference {
        return _REF_5Y
    }
    
    var REF_VOCABULARY: DatabaseReference {
        return _REF_VOCABULARY
    }
    
    var REF_SOMETHING: DatabaseReference {
        return _REF_SOMETHING
    }
    
    var STORAGE_24M: StorageReference {
        return _STORAGE_24M
    }
    
    var STORAGE_3Y: StorageReference {
        return _STORAGE_3Y
    }
    
    var STORAGE_4Y: StorageReference {
        return _STORAGE_4Y
    }
    
    var STORAGE_5Y: StorageReference {
        return _STORAGE_5Y
    }
    
    var STORAGE_VOCABULARY: StorageReference {
        return _STORAGE_VOCABULARY
    }
    
    var STORAGE_SOMETHING: StorageReference {
        return _STORAGE_SOMETHING
    }
}
