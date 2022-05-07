//
//  MyPageViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/12/01.
//

import RxSwift
import RxCocoa

final class MyPageViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<MyPageState>(value: MyPageState())
    private let disposeBag = DisposeBag()
    private let firebaseReadable: FirebaseReadable
    private var paySumPublish = PublishSubject<Int>()
    
    init(firebaseReadable: FirebaseReadable){
        self.firebaseReadable = firebaseReadable
    }
    
    struct Input{
        let viewState: Observable<Void>?
    }
    
    struct Output{
        var state: Driver<MyPageState>?
    }
    
    func bind(input: Input) -> Output{
        self.input = input
        
        input.viewState?
            .withLatestFrom(state){ [weak self] _, state -> MyPageState in
                guard let self = self else { return state }
                var newState = state
                newState.viewLogic = .setUpView
                self.firebaseReadable.readBookInfo { result in
                    self.bookInfoList(result: result)
                }
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
    
        paySumPublish
            .withLatestFrom(state){ sum, state -> MyPageState in
                var newState = state
                print("get list successly")
                newState.paySum = sum
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        return Output(state: state.asDriver())
    }
    
}
extension MyPageViewModel{
    private func bookInfoList(result: Result<[BookInfo], FireBaseError>) {
        switch result{
        case .success(let bookList):
            var sum: Int = 0
            for book in bookList{
                guard let price = Int(book.price) else { return }
                sum += price
            }
            paySumPublish.onNext(sum)
        case .failure(let error):
            print(error)
        }
    }
}

struct MyPageState{
    var viewLogic: ViewLogic?
    var paySum: Int?
}
