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

        repository.getFileURL()
        
        folder = repository.fetchAll()
        
        layout()
        configureDataSource()
        updateSnapshot()
        
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        folder = repository.fetchAll()
        forceUpdateSnapshot()
    }
    

    private func updateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Folder>()
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(folder, toSection: Section.first)
        dataSource.apply(snapshot)
        
    }
    
    private func forceUpdateSnapshot() {
        // 화면전환시 Id로만 비교하다보니, 내부에 값이 바뀌어도 다시 업데이트를 하지 않음
        // 강제 업데이트
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems(folder)
        dataSource.apply(snapshot)
    }
    

    



}

extension WishListFolderViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = WishListViewController()
        vc.id = folder[indexPath.item].id
        vc.list = Array(folder[indexPath.item].wishList)
        vc.itemTitle = folder[indexPath.item].title
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

// MARK: - Layout 및 셀 설정
extension WishListFolderViewController {
    
    private func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

    
    }
    
    private func configureDataSource() {
        
        let registration: UICollectionView.CellRegistration  = UICollectionView.CellRegistration<UICollectionViewListCell, Folder>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.image = UIImage(systemName: "pencil.circle")
            
            content.text = itemIdentifier.title
            content.textProperties.color = .white
            content.textProperties.font = .boldSystemFont(ofSize: 20)
            
            content.secondaryText = "\(itemIdentifier.wishList.count)개"
            
            content.secondaryTextProperties.color = .systemGray

            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfig.backgroundColor = .black
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
        congifuration.backgroundColor = .black
        let layout = UICollectionViewCompositionalLayout.list(using: congifuration)
        
        return layout
        
    }
}

