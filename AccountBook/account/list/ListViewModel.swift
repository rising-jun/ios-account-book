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
    
}
