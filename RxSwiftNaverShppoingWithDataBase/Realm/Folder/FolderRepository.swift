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
    
}


final class FolderTableRepository: FolderRepository {
    
    private let realm = try! Realm()
    
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
    
    func fetchAll() -> [Folder] {
        let object = realm.objects(Folder.self)
    
        return Array(object)
    }
    
    
    
    
    
    
}
