//
//  ListViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseDatabase

class ListViewModel{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<ListViewState>(value: ListViewState())
    
    struct Input{
        let viewState: Observable<ViewState>?
        let writeTouch: Observable<Void>?
    }
    
    struct Output{
        var state: Driver<ListViewState>?
    }
    
    private let disposeBag = DisposeBag()
    
    func bind(input: Input) -> Output{
        self.input = input
            
        input.viewState?
            .filter{$0 == .viewDidLoad}
            .withLatestFrom(state){[weak self] viewState, state -> ListViewState in
                var newState = state
                newState.viewLogic = .setUpView
                newState.filterData = ["높은금액순", "최신순", "카테고리 별"]
                self?.getListModelFB()
                newState.listData = [BookInfo(name: "지출시험", lat: 0.0, long: 0.0, price: "3000", category: "유흥", date: "2021-11-12 16:32")]
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.writeTouch?
            .withLatestFrom(state)
            .map{ [weak self] state -> ListViewState in
                var newState = state
                newState.presentVC = .write
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        output = Output(state: state.asDriver())
        return output!
    }
}

extension ListViewModel{
    func getListModelFB(){
        if let userId = UserDefaults.standard.string(forKey: "token"){
            print("what is userId \(userId)")
//            let ref = Database.database().reference(withPath: userId)
//            let jsonEncoder = JSONEncoder()
//            let bookInfo = BookInfo(name: "밥", lat: 1.0, long: 2.0, price: "30000", category: "새로카테고리", date: "2021-11-12 17:55")
//            let jsonData = try! jsonEncoder.encode(bookInfo)
//            let json = String(data: jsonData, encoding: String.Encoding.utf8)
//            let accountRef = ref.child("account")
//            accountRef.child("1").setValue(json)
            //TODO token에 .이 들어가는거 빼기, 파이어베이스 값 저장 조건 생각하기
        }
//        let ref = Database.database().reference(withPath: "userId")
//        ref.observe(.value) { snapShot in
//            print("snapShot!! \(snapShot)")
//        }
//
    }
    
}

struct ListViewState{
    var presentVC: PresentVC?
    var viewLogic: ViewLogic?
    var filterData: [String]?
    var listData: [BookInfo]?
    
}
