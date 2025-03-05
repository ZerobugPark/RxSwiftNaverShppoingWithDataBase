//
//  WishListRepository.swift
//  RxSwiftNaverShppoingWithDataBase
//
//  Created by youngkyun park on 3/5/25.
//

import Foundation
import RealmSwift


protocol WishListRepository {
    
    
    func fetchAll() -> [WishList]
    func createItem(item: String, date: String)
    func deleteItem(data: WishList)
    
    func createItemInFolder(folder: Folder, item: String, date: String)
}


final class WishListTableRepository: WishListRepository {
    
    private let realm = try! Realm()
    
    func fetchAll() -> [WishList] {
        let object = realm.objects(WishList.self)
    
        return Array(object)
    }
    
    func createItem(item: String, date: String) {
        do {
            try realm.write {
                let data = WishList(item: item, date: date)
                realm.add(data)
            }
        } catch {
          print("아이템 추가 실패")
        }
    }
    
    func deleteItem(data: WishList) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("삭제 실패")
        }
        
    }
    
    func createItemInFolder(folder: Folder, item: String, date: String) {
        
        do {
            try realm.write {
                
                let data = WishList(item: item, date: date)
                
                folder.wishList.append(data)
            }
        } catch {
            print("렘에 저장이 실패")
        }
        
        
    }
    

}
