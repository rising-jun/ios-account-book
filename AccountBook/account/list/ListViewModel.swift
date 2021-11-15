//
//  ListViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

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
                self?.writeListFB()
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
    func writeListFB(){
        if let userToken = UserDefaults.standard.string(forKey: "token"){
            print("what is userId \(userToken)")
            
//            let db = Firestore.firestore()
//            db.collection("account_array").document("accountData").updateData(["DiaryList" : FieldValue.ar([
//                "userId": userToken,
//                "name": "Los Angeles",
//                "price": "30000",
//                "category": "USA",
//                "lat": 1,
//                "long": 2,
//                "date": "2021-11-15 10:20"]
//            ]){ err in
//                if let err = err {
//                    print("Error writing document: \(err)")
//                } else {
//                    print("Document successfully written!")
//                }
//            }
            
        }
        
    }
    
    func getListModelFB(){
        let db = Firestore.firestore()
        let ref = db.collection("account_array").document("account_info")
            .getDocument{ (document, error) in
                
                // Construct a Result type to encapsulate deserialization errors or
                // successful deserialization. Note that if there is no error thrown
                // the value may still be `nil`, indicating a successful deserialization
                // of a value that does not exist.
                //
                // There are thus three cases to handle, which Swift lets us describe
                // nicely with built-in Result types:
                //
                //      Result
                //        /\
                //   Error  Optional<City>
                //               /\
                //            Nil  City
                let result = Result {
                    try document?.data()
                }
                switch result {
                case .success(let city):
                    if let city = city {
                        // A `City` value was successfully initialized from the DocumentSnapshot.
                        print("City: \(city)")
                    } else {
                        // A nil value was successfully initialized from the DocumentSnapshot,
                        // or the DocumentSnapshot was nil.
                        print("Document does not exist")
                    }
                case .failure(let error):
                    // A `City` value could not be initialized from the DocumentSnapshot.
                    print("Error decoding city: \(error)")
                }
            }
        
        
    }
    
}

struct ListViewState{
    var presentVC: PresentVC?
    var viewLogic: ViewLogic?
    var filterData: [String]?
    var listData: [BookInfo]?
    
}
