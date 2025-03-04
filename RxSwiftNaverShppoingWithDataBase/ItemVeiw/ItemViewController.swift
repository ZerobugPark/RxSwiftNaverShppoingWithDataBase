//
//  ItemViewController.swift
//  RxSwiftNaverShppoingWithDataBase
//
//  Created by youngkyun park on 3/4/25.
//

import UIKit

import RxSwift
import RxCocoa
import Toast

final class ItemViewController: UIViewController {

    private let itemView = ItemView()
    let viewModel = ItemViewModel()
    
    private var disposeBag = DisposeBag()
    
    
    private let likeButtonTapped = PublishRelay<Int>()
    
    override func loadView() {
        view = itemView
    }


    override func viewDidLoad() {
        super.viewDidLoad()

       
        itemView.collectionView
            .register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.id)
    
        bind()

        
    }
    
    private func bind() {
        
        let input = ItemViewModel.Input(viewDidLoad: Observable.just(()), filterButton: Observable.merge(itemView.buttons[0].rx.tap.map { [weak self] in self?.itemView.buttons[0].tag ?? 0}, itemView.buttons[1].rx.tap.map { [weak self] in self?.itemView.buttons[1].tag ?? 1}, itemView.buttons[2].rx.tap.map { [weak self] in self?.itemView.buttons[2].tag ?? 2}, itemView.buttons[3].rx.tap.map { [weak self] in self?.itemView.buttons[3].tag ?? 3}),likebuttonTapped: likeButtonTapped)
                

        let output = viewModel.transform(input: input)
     
        output.shoppingInfo.asDriver()
            .drive(itemView.collectionView.rx.items(cellIdentifier: ItemCollectionViewCell.id, cellType: ItemCollectionViewCell.self)) { [weak self] item, element, cell in
                
                cell.updateItemList(item: element)

                let image = element.isLike ? "heart.fill" : "heart"
                cell.likeBtn.setImage(UIImage(systemName: image), for: .normal)
                print(element.link)
                
                cell.likeBtn.rx.tap.bind { _ in

                    self?.likeButtonTapped.accept((item))
                    self?.view.makeToast("아이템이 추가되었습니다.", duration: 1.0)
   
                }.disposed(by: cell.disposeBag)


            }.disposed(by: disposeBag)
        
    
        
        
        itemView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        output.viewDidLoad.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        
        output.itemInfo.asDriver().drive(itemView.resultCountLabel.rx.text).disposed(by: disposeBag)
        
        output.buttonStatus.asDriver(onErrorJustReturn: "").drive(with: self) { owner, value in
            
            var tag = 0
            switch value {
            case Sorts.sim.rawValue:
                tag = 0
            case Sorts.date.rawValue:
                tag = 1
            case Sorts.dsc.rawValue:
                tag = 2
            case Sorts.asc.rawValue:
                tag = 3
            default:
                tag = 0
                
            }
            owner.changeButtonColor(tag: tag)
            
        }.disposed(by: disposeBag)
        
        output.isEmpty.asDriver(onErrorJustReturn: false).drive(with: self) { owner, status in
            
            if status {
                print("찾는게 없습니다")
            } else {
                owner.itemView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }.disposed(by: disposeBag)
            

        
        output.errorMsg.asDriver(onErrorJustReturn: "").drive(with: self) { owner, msg in
            let alert = UIAlertController(title: "API 통신 오류", message: msg, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(ok)
            owner.present(alert, animated: true)
            
            
        }.disposed(by: disposeBag)
    }
    
    
    private func changeButtonColor(tag: Int) {
        //버튼 뷰 업데이트
        for i in 0..<itemView.buttons.count {
            if i == tag {
                itemView.buttons[i].configuration?.baseForegroundColor = .black
                itemView.buttons[i].configuration?.baseBackgroundColor = .white

            } else {
                itemView.buttons[i].configuration?.baseForegroundColor = .white
                itemView.buttons[i].configuration?.baseBackgroundColor = .black

            }
        }
    }
    
    deinit {
        
        print("ItemViewController Deinit")
    }
  
}



// MARK: - UICollectionViewDelegateFlowLayOut
extension ItemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let deviceWidth = view.frame.width
        
        let spacing: CGFloat = 16
        let inset: CGFloat = 16
        
        let objectWidth = (deviceWidth - (spacing + (inset*2))) / 2
       
        
        return CGSize(width: objectWidth, height: objectWidth * 1.5)
    }
  
}
