//
//  WishListViewController.swift
//  RxSwiftNaverShopping
//
//  Created by youngkyun park on 2/26/25.
//

import UIKit
import RealmSwift

final class WishListViewController: UIViewController {
    
    
    enum Section: CaseIterable {
        case main
    }
        
    var dataSource: UICollectionViewDiffableDataSource<Section, WishList>!
    
    var id: ObjectId!
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    private let searchBar = UISearchBar()
    
    var list: [WishList] = []
    var itemTitle: String = ""
    let repository: WishListRepository = WishListTableRepository()
    let folderRepository: FolderRepository = FolderTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        

        configurationLayout()
        configureDataSource()
        updataSnapshot()
        searchBar.delegate = self
        collectionView.delegate = self
        
        navigationItem.title = itemTitle
    }
    
    private func updataSnapshot() {
        
        var snopshot = NSDiffableDataSourceSnapshot<Section, WishList>()
        
        snopshot.appendSections(Section.allCases)
        snopshot.appendItems(list, toSection: .main)
        
        dataSource.apply(snopshot)
        
    }
    
    
    
 


}
// MARK: - CollectionViewDelegate Delegate
extension WishListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = list[indexPath.item]

        //repository.deleteItem(data: data)
        // 부모는 삭제가 되는데 자식은 삭제가 안됨
        // 그렇다고 자식도 삭제하고 부모가 삭제하면, Realm데이터를 찾을 수 없음 (스냅샷 업데이트시)
        // 추가는 같이되면서, 삭제는 왜 같이 안되는거지?..
        folderRepository.deleteItem(parentsId: id, childId: data.id)
    
        let refreshData = folderRepository.fetchAll().filter { $0.id == id}.first!
        
        list = Array(refreshData.wishList)
        
        
        
        updataSnapshot()
        
        
        
    }
}


// MARK: - SearchBar Delegate
extension WishListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd HH.mm"
        let date = dateFormatter.string(from: Date())
        
        
        
        for item in list {
            if item.item == text {
                return
            }
        }
        
        
        let folder = folderRepository.fetchAll().filter { $0.id == id }
        
        repository.createItemInFolder(folder: folder[0], item: text, date: date)
        
        let refreshData = folderRepository.fetchAll().filter { $0.id == id}.first!
        
        list = Array(refreshData.wishList)
        
        
        updataSnapshot()
        
    }
}


// MARK: - layOut 및 셀 설정
extension WishListViewController {
    
    
    private func configurationLayout() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchBar.backgroundColor = .clear
        collectionView.backgroundColor = .black
    }
    
    private func configureDataSource() {
        
        
        let registration: UICollectionView.CellRegistration<UICollectionViewListCell, WishList> = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier.item
            content.textProperties.color = .black
            content.textProperties.font = .boldSystemFont(ofSize: 16)
            
            content.secondaryText = itemIdentifier.date
            content.textProperties.color = .systemGray
            content.textProperties.font = .systemFont(ofSize: 13)
           
            
            cell.contentConfiguration = content
            
            var backGroundConfig = UIBackgroundConfiguration.listGroupedCell()
            backGroundConfig.backgroundColor = .white
            backGroundConfig.cornerRadius = 5
            backGroundConfig.strokeWidth = 2
            backGroundConfig.strokeColor = .systemGray6
            
            cell.backgroundConfiguration = backGroundConfig
            
            
        }
        
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            
            return cell
            
        })
        
    }
    

    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .black
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        
        return layout
    }
}
