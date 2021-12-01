//
//  MyPageViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/12/01.
//

import Foundation
import RxSwift
import RxCocoa

class MyPageViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<MyPageState>(value: MyPageState())
    private let disposeBag = DisposeBag()
    
    private var fbReadModel: FirebaseReadModel!
    
    private var paySumPublish = PublishSubject<Int>()
    
    
    struct Input{
        let viewState: Observable<Void>?
        
    }
    
    struct Output{
        var state: Driver<MyPageState>?
    }
    
    func bind(input: Input) -> Output{
        self.input = input
        fbReadModel = FirebaseReadModel(fbCallBack: self)
        
        input.viewState?
            .withLatestFrom(state){ [weak self] _, state -> MyPageState in
                var newState = state
                newState.viewLogic = .setUpView
                self!.fbReadModel.readBookInfo()
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
        
        output = Output(state: state.asDriver())
        return output!
    }
    
}

struct MyPageState{
    var viewLogic: ViewLogic?
    var paySum: Int?
}

extension MyPageViewModel: FirebaseReadProtocol{
    func bookInfoList(bookList: [BookInfo]) {
        var sum: Int = 0
        for i in bookList{
            sum += Int(i.price) ?? 0
        }
        paySumPublish.onNext(sum)
    }
    
}
