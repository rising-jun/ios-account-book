//
//  ListViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxSwift
import RxCocoa

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
            .withLatestFrom(state){ viewState, state -> ListViewState in
                var newState = state
                newState.viewLogic = .setUpView
                newState.filterData = ["높은금액순", "최신순", "카테고리 별"]
                newState.listData = [BookInfo(name: "지출시험", lat: 0.0, long: 0.0, price: "3000", category: "유흥", date: Date())]
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

struct ListViewState{
    var presentVC: PresentVC?
    var viewLogic: ViewLogic?
    var filterData: [String]?
    var listData: [BookInfo]?
    
}
