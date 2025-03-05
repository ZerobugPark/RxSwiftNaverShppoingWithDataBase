//
//  FolderRepository.swift
//  RxSwiftNaverShppoingWithDataBase
//
//  Created by youngkyun park on 3/5/25.
//

import Foundation


import RealmSwift

protocol FolderRepository {
    func getFileURL()
    func createItem(title: String)
    func fetchAll() -> [Folder]
    func deleteItem(parentsId: ObjectId, childId: ObjectId)
}


final class FolderTableRepository: FolderRepository {
    
    private let realm = try! Realm()
    
    
    init() {
        
        
        Folder.initiaiData()
    }
    
    func getFileURL() {
        print(realm.configuration.fileURL)
    }
    
    
    func createItem(title: String) {
        
        do {
            try realm.write {
                let folder = Folder(title: title)
                realm.add(folder)
            }
        } catch {
            print("폴더 저장 오류")
        }
        
    }
    
    func deleteItem(parentsId: ObjectId, childId: ObjectId) {
        do {
            try realm.write {
                
                let parents = realm.objects(Folder.self).where { $0.id == parentsId}.first!
                print(childId)
                guard let child = parents.wishList.firstIndex(where: { $0.id == childId })
                else {
                    print("일치하는 자식 아이디가 없습니다.")
                    return 
                }
                parents.wishList.remove(at: child)
                      
            }
        } catch {
            print("삭제 실패")
        }
        
    }
    
    
    func fetchAll() -> [Folder] {
        let object = realm.objects(Folder.self)
    
        return Array(object)
    }
    

    
    
    
    
    
}
