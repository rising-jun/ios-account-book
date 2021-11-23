//
//  ChartViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/23.
//

import Foundation
import RxSwift
import RxCocoa

class ChartViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<ChartState>(value: ChartState())
    private let disposeBag = DisposeBag()
    
    private var fbReadModel: FirebaseReadModel!
    
    private var bookListPublish = PublishSubject<[BookInfo]>()
    
    
    struct Input{
        let viewState: Observable<Void>?
        
    }
    
    struct Output{
        var state: Driver<ChartState>?
    }
    
    func bind(input: Input) -> Output{
        self.input = input
        fbReadModel = FirebaseReadModel(fbCallBack: self)
        
        input.viewState?
            .withLatestFrom(state){ [weak self] _, state -> ChartState in
                var newState = state
                newState.viewLogic = .setUpView
                self!.fbReadModel.readBookInfo()
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
    
        bookListPublish
            .withLatestFrom(state){ list, state -> ChartState in
                var newState = state
                newState.listData = list
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        output = Output(state: state.asDriver())
        return output!
    }
    
}

struct ChartState{
    var presentVC: PresentVC?
    var viewLogic: ViewLogic?
    var listData: [BookInfo]?
}

extension ChartViewModel: FirebaseReadProtocol{
    func bookInfoList(bookList: [BookInfo]) {
        bookListPublish.onNext(bookList)
    }
    
    
}
