//
//  IntroViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxSwift
import RxCocoa

final class IntroViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<IntroState>(value: IntroState())
    
    struct Input{
        let timeOver: Observable<Bool>?
        let viewState: Observable<ViewState>?
    }
    
    struct Output{
        var state: Driver<IntroState>?
    }
    
    private let disposeBag = DisposeBag()
    
    func bind(input: Input) -> Output{
        self.input = input

        input.timeOver?
            .withLatestFrom(state){ done, state -> IntroState in
                var newState = state
                newState.presentVC = .login
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
            
        input.viewState?
            .filter{$0 == .viewDidLoad}
            .withLatestFrom(state){ viewState, state -> IntroState in
                var newState = state
                newState.viewLogic = .setUpView
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        output = Output(state: state.asDriver())
        return output!
    }
    
    
}



struct IntroState{
    var presentVC: PresentVC?
    var timeOver: Bool?
    var viewLogic: ViewLogic?
    
}

enum ViewLogic{
    case setUpView
}
