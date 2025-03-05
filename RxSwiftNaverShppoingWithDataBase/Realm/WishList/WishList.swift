//
//  WishList.swift
//  RxSwiftNaverShppoingWithDataBase
//
//  Created by youngkyun park on 3/5/25.
//

import Foundation
import RealmSwift


final class WishList: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var item: String
    @Persisted var date: String
    
    @Persisted(originProperty: "wishList")
    var folder: LinkingObjects<Folder>
    
    
    convenience init(item: String, date: String) {
        self.init()
        self.item = item
        self.date = date
    }
    
}


