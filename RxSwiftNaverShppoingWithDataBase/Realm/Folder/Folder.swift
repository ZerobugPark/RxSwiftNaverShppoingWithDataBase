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
    
    
    static func initiaiData() {
        
        let key = "initData"
        let defaults = UserDefaults.standard.bool(forKey: key)
      
        
        if !defaults {
            
            let realm = try! Realm()
            
            do {
                try realm.write {
                    
                    let list1 = Folder(title: "오늘 할 일")
                    let list2 = Folder(title: "이번 주 할 일")
                    let list3 = Folder(title: "이번 달 할 일")
                    
                    
                    realm.add([list1, list2, list3])
                }
            } catch {
                print("초기설정 오류")
            }
            
            UserDefaults.standard.set(true, forKey: key)
        }
    }
}
