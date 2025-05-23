//
//  ItemViewModel.swift
//  RxSwiftNaverShppoingWithDataBase
//
//  Created by youngkyun park on 3/4/25.
//

import Foundation

import RxSwift
import RxCocoa
import RealmSwift

final class ItemViewModel: BaseViewModel {

    struct Input {
        let viewDidLoad: Observable<Void>
        let filterButton: Observable<Int>
        let likebuttonTapped: PublishRelay<Int>
    }
    
    struct Output {
        let shoppingInfo: BehaviorRelay<[Item]>
        let viewDidLoad: Observable<String>
        let itemInfo: BehaviorRelay<(String)>
        let errorMsg: PublishRelay<String>
        let buttonStatus: PublishRelay<String>
        let isEmpty: PublishRelay<Bool>
    }
    
    private let disposeBag = DisposeBag()
    
    private var data: [Item] = []
    
    private var filter = Sorts.sim.rawValue
    
    var query = ""
    
    private let realm = try! Realm()
    
    init() {
        print("ItemViewModel Init")
        //print(realm.configuration.fileURL)
    }
    
    
    func transform(input: Input) -> Output {
        
        let shoppingInfo = BehaviorRelay(value: data)
        let title = Observable.just(query)
        let total = BehaviorRelay(value: "")
        let errorMsg = PublishRelay<String>()
        let buttonStatus = PublishRelay<String>()
        let isEmpty = PublishRelay<Bool>()
        
        
        input.viewDidLoad.flatMap {
            NetworkManagerRxSwift.shared.callRequest(api: .getInfo(query: self.query, display: 100, sort: self.filter, startIndex: 1))
        }.bind(with: self) { owner, response in
            
            switch response {
            case .success(let value):
                owner.data = value.items
                
                shoppingInfo.accept(owner.data)
                
                let msg = value.total.formatted() + " 개의 검색 결과"
                total.accept(msg)
               
            case .failure(let error):
                var msg = ""
                switch error {
                case .invalidURL:
                    msg = "잘못된 URL"
                case .queryCheck:
                    msg = "요청 변수 확인"
                case .authenticationFailed:
                    msg = "인증 실패"
                case .forbid:
                    msg = "HTTPS가 아닌 HTTP로 호출한 경우"
                case .noneApi:
                    msg = "API 없음"
                case .checkHTTPMethod:
                    msg = "메서드 허용 안 함"
                case .limitedRequest:
                    msg = "호출 한도 초과 오류"
                case .serverError:
                    msg = "서버 오류"
                case .unknown:
                    msg = "알려지지 않음"
                case .JsonError:
                    msg = "Data 확인"
                case .decodingError:
                    msg = "구조체 오류"
                
                }
                
                errorMsg.accept(msg)
            }
            
            
        }.disposed(by: disposeBag)
        
        
        input.filterButton.map { tag in
            
            switch tag {
            case 0:
                return Sorts.sim.rawValue
            case 1:
                return Sorts.date.rawValue
            case 2:
                return Sorts.dsc.rawValue
            case 3:
                return Sorts.asc.rawValue
            default:
                return Sorts.sim.rawValue
            }
            
        }.flatMap { tag in
            
            NetworkManagerRxSwift.shared.callRequest(api: .getInfo(query: self.query, display: 100, sort: tag, startIndex: 1))
                .map { response in
                    self.filter = tag
                    return (tag, response)
            }

        }.bind(with: self) { owner, value in

            switch value.1 {
            case .success(let response):
                owner.data = response.items
                shoppingInfo.accept(owner.data)
                if owner.data.isEmpty {
                    isEmpty.accept(true)
                } else {
                    isEmpty.accept(false)
                }
                buttonStatus.accept(value.0)
            case .failure(let error):

                var msg = ""
                switch error {
                case .invalidURL:
                    msg = "잘못된 URL"
                case .queryCheck:
                    msg = "요청 변수 확인"
                case .authenticationFailed:
                    msg = "인증 실패"
                case .forbid:
                    msg = "HTTPS가 아닌 HTTP로 호출한 경우"
                case .noneApi:
                    msg = "API 없음"
                case .checkHTTPMethod:
                    msg = "메서드 허용 안 함"
                case .limitedRequest:
                    msg = "호출 한도 초과 오류"
                case .serverError:
                    msg = "서버 오류"
                case .unknown:
                    msg = "알려지지 않음"
                case .JsonError:
                    msg = "Data 확인"
                case .decodingError:
                    msg = "구조체 오류"

                }

                errorMsg.accept(msg)
            }



        }.disposed(by: disposeBag)
        
        input.likebuttonTapped.asDriver(onErrorJustReturn: 0).drive(with: self) { owner, value in
            
            owner.data[value].isLike.toggle()
            
            
            // 중복은 어떻게 제거하는게 좋을까? (중복제거 관련 코드 추가가 필요함)
            // 새로 생성하다보면 id가 다르기 때문에, 중복으로 생성되는 이슈가 있음
            
            
            
            let data = LikeItemTable(title: owner.data[value].title, mallName: owner.data[value].mallName, price: owner.data[value].lprice, isliked: owner.data[value].isLike, imgURL: owner.data[value].image)
            
            
            do {
                
                try owner.realm.write {
                    owner.realm.add(data)
                    print("렘 저장 완료")
                }
            } catch {
                print("렘 저장 실패")
            }
            
            shoppingInfo.accept(owner.data)
            
            
            
            
            
        }.disposed(by: disposeBag)
        
     
        return Output(shoppingInfo: shoppingInfo, viewDidLoad: title, itemInfo: total, errorMsg: errorMsg, buttonStatus: buttonStatus, isEmpty: isEmpty)
    }
    
    
    
    deinit {
        print("ItemViewModel DeInit")
    }
}
