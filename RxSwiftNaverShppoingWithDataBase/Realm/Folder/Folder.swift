//
//  Folder.swift
//  RxSwiftNaverShppoingWithDataBase
//
//  Created by youngkyun park on 3/5/25.
//

import Foundation
import RealmSwift


final class Folder: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var title: String
    @Persisted var wishList: List<WishList>
    
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    convenience override init() {
        self.init()
        
        
        let defaults = UserDefaults.standard
        let key = "init"
    }
}
