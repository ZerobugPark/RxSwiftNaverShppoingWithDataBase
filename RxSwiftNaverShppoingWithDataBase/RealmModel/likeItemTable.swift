//
//  likeItemTable.swift
//  RxSwiftNaverShppoingWithDataBase
//
//  Created by youngkyun park on 3/4/25.
//

import Foundation
import RealmSwift


final class LikeItemTable: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted(indexed: true) var title: String
    @Persisted var mallName: String
    @Persisted var price: String
    @Persisted var isLiked: Bool
    @Persisted var imgURL: String
    
    
    
    convenience init (title: String, mallName: String, price: String, isliked: Bool, imgURL: String) {
        self.init()
        self.title = title
        self.mallName = mallName
        self.price = price
        self.isLiked = isliked
        self.imgURL = imgURL
    }
    

    
}
