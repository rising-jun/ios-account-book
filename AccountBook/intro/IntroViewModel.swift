//
//  IntroViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import RxSwift
import RxCocoa

final class IntroViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    init(timer: TimerUsable){
        self.timer = timer
    }
    
    private let state = BehaviorRelay<IntroState>(value: IntroState())
    private let timer: TimerUsable
    private let presentSubject = PublishSubject<ViewControllerType>()
    struct Input{
        let viewState: Observable<ViewState>?
    }
    
    struct Output{
        var state: Driver<IntroState>?
    }
    
    private let disposeBag = DisposeBag()
    
    func bind(input: Input) -> Output{
        self.input = input
        presentSubject.withLatestFrom(state){ _, state -> IntroState in
            var newState = state
            newState.presentViewController = .login
            return newState
        }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.viewState?
            .filter{$0 == .viewDidLoad}
            .withLatestFrom(state){ viewState, state -> IntroState in
                var newState = state
                newState.viewLogic = .setUpView
                self.timer.timerStart { result in
                    self.timerStarted(result: result)
                }
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        return Output(state: state.asDriver())
    }
    
    private func timerStarted(result: Result<Void, TimerError>){
        switch result{
        case .success(_):
            presentSubject.onNext(.login)
        case .failure(let error):
            print(error)
        }
    }
}

struct IntroState{
    var presentViewController: ViewControllerType?
    var timeOver: Bool?
    var viewLogic: ViewLogic?
    
}

enum ViewLogic{
    case setUpView
}
