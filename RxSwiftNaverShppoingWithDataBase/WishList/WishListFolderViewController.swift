//
//  WishListFolderViewController.swift
//  RxSwiftNaverShppoingWithDataBase
//
//  Created by youngkyun park on 3/5/25.
//

import UIKit
import SnapKit
import RealmSwift

class WishListFolderViewController: UIViewController {
    
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    
    
    enum Section: CaseIterable {
        case first
    }
    
    let repository: FolderRepository = FolderTableRepository()
    var list: Results<Folder>!
    
    var folder = [Folder]()
    
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Folder>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        repository.createItem(title: "오늘 할 일")
//        repository.createItem(title: "이번 주 할 일")
//        repository.createItem(title: "이번 달 할 일")
//        
        repository.getFileURL()
        
        folder = repository.fetchAll()
      
        layout()
        configureDataSource()
        updateSnapshot()
    }
    
    private func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.backgroundColor = .blue
        
    }
    
    private func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Folder>()
        
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(folder, toSection: Section.first)
        dataSource.apply(snapshot)
        
    }
    
    
    private func configureDataSource() {
        
        let registration: UICollectionView.CellRegistration  = UICollectionView.CellRegistration<UICollectionViewListCell, Folder>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.image = UIImage(systemName: "pencil.circle")
            
            content.text = itemIdentifier.title
            content.textProperties.color = .black
            content.textProperties.font = .boldSystemFont(ofSize: 20)
            
            content.secondaryText = "\(itemIdentifier.wishList.count)개"
            content.secondaryTextProperties.color = .systemGray

            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfig.backgroundColor = .white
            backgroundConfig.cornerRadius = 10
            
            cell.backgroundConfiguration = backgroundConfig
            
            
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        
        var congifuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        congifuration.backgroundColor = .white
        let layout = UICollectionViewCompositionalLayout.list(using: congifuration)
        
        return layout
        
    }



}

