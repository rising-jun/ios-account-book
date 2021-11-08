//
//  WriteViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/08.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class WriteViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<WriteState>(value: WriteState())
    
    struct Input{
        let viewState: Observable<ViewState>?
        let locationStatus: Observable<CLAuthorizationStatus>?
    
    }
    
    struct Output{
        var state: Driver<WriteState>?
    }
    
    private let disposeBag = DisposeBag()
    
    func bind(input: Input) -> Output{
        self.input = input
            
        input.viewState?
            .filter{$0 == .viewDidLoad}
            .withLatestFrom(state){ viewState, state -> WriteState in
                var newState = state
                newState.viewLogic = .setUpView
                newState.categoryData = ["식비", "생활비", "유흥비"]
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.locationStatus?
            .withLatestFrom(state){ a,state -> WriteState in
                var newState = state
                print("view model \(a)") //TODO get location 
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        output = Output(state: state.asDriver())
        return output!
    }
}

struct WriteState{
    var presentVC: PresentVC?
    var viewLogic: ViewLogic?
    var categoryData: [String]?
    var locationPermission: CLAuthorizationStatus?
}
