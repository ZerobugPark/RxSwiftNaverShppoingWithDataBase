//
//  ItemLikeViewController.swift
//  RxSwiftNaverShppoingWithDataBase
//
//  Created by youngkyun park on 3/4/25.
//

import UIKit
import SnapKit
import RealmSwift
import Toast

final class ItemLikeViewController: UIViewController {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    private let searchBar = UISearchBar()
    
    private let realm = try! Realm()
    
    private var list: Results<LikeItemTable>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        navigationItem.title = "좋아요 리스트"
        
//        // 네비게이션 바 투명하게 만들기 (컬렉션뷰가 수직이면서, 전체를 차지할 때 네비게이션의 색상이 영역이 바뀜)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true // 상태바 T: 투명, F: 불투명
        
        list = realm.objects(LikeItemTable.self)
        
        layout()
        
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.id)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        searchBar.delegate = self
    }
    
    deinit {
        print("ItemLikeViewController Deinit")
    }
    

 

}

// MARK: - Delegate
extension ItemLikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.id, for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell() }
        
        let data = list[indexPath.row]
        cell.updateItemList(item: data)
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        return cell
        
    }
    
    
}

// MARK: - OBJ Function
extension ItemLikeViewController {
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        
        let data = list[sender.tag]
        do {
            try realm.write {
                realm.delete(data)
                collectionView.reloadData()
                
                view.makeToast("아이템이 삭제되었습니다.", duration: 1.0)
            }
            
        } catch {
            
        }
 
    }
}

extension ItemLikeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else { return }
        
                
        list = realm.objects(LikeItemTable.self).where{
            $0.title.contains(text, options: .caseInsensitive)
        }
        
        
        collectionView.reloadData()
        
       
    }
}



// MARK: - layout
extension ItemLikeViewController {
    
    private func layout() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.backgroundColor = .clear
        
        
        let placeholder = "찾으실 상품명을 입력해주세요."
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        searchBar.layer.borderWidth = 10
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1098035797, green: 0.1098041758, blue: 0.122666128, alpha: 1)
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchBar.searchTextField.tokenBackgroundColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchBarStyle = .minimal
        
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let deviceWidth = view.frame.width
        let inset: CGFloat = 16
        let spacing: CGFloat = 16
        let objectWidth = (deviceWidth - (spacing + (inset*2))) / 2
        
        layout.itemSize = CGSize(width: objectWidth, height: objectWidth * 1.5)
        
        
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: 0, right: inset)
        layout.scrollDirection = .vertical
        
        return layout
    }
}


