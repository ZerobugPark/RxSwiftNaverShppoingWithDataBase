//
//  SearchViewController.swift
//  RxSwiftNaverShppoingWithDataBase
//
//  Created by youngkyun park on 3/4/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit


class SearchViewController: UIViewController {

    private let searchBar = UISearchBar()

    private let viewModel = SearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    
    private let rightButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "오늘도 쇼핑쇼핑"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
           
        navigationItem.rightBarButtonItem = rightButton
        
        
        configuration()
        bind()
    }
    
    private func bind() {
    
        let input = SearchViewModel.Input(searchButton: searchBar.rx.searchButtonClicked,
                                            searchText: searchBar.rx.text.orEmpty)
        


        let output = viewModel.transform(input: input)
        
            
        output.alertMsg.asDriver(onErrorJustReturn: "").drive(with: self) { owner, msg in
            let alert = UIAlertController(title: "알림", message: "2글자 이상 입력해주세요", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel)
            
            alert.addAction(ok)
            owner.present(alert,animated: true)
            
        }.disposed(by: disposeBag)
        
        output.searchItem.asDriver(onErrorJustReturn: "").drive(with: self) { owner, text in
            let vc = ItemViewController()
            
            vc.viewModel.query = text
            
            owner.navigationController?.pushViewController(vc, animated: true)
            
        }.disposed(by: disposeBag)
        
        
  
    }

}


extension SearchViewController {
    
    private func configuration() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
   
    
    private func configureHierarchy() {
        view.addSubview(searchBar)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(4)
            
        }
        
    }
    
    private func configureView() {
        let placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        searchBar.layer.borderWidth = 10
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1098035797, green: 0.1098041758, blue: 0.122666128, alpha: 1)
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchBar.searchTextField.tokenBackgroundColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchBarStyle = .minimal
       
        
        view.backgroundColor = .black

    }

}
