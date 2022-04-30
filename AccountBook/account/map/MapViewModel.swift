//
//  MapViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/18.
//

import Foundation
import RxSwift
import RxCocoa

class MapViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<MapState>(value: MapState())
    private let disposeBag = DisposeBag()
    
    private var fbReadModel = FirebaseReadRepository()
    
    private var bookListPublish = PublishSubject<[BookInfo]>()
    
    
    struct Input{
        let viewState: Observable<Void>?
        
    }
    
    struct Output{
        var state: Driver<MapState>?
    }
    
    func bind(input: Input) -> Output{
        self.input = input
        
        input.viewState?
            .withLatestFrom(state){ [weak self] _, state -> MapState in
                var newState = state
                newState.viewLogic = .setUpView
                self!.fbReadModel.readBookInfo { result in
                    
                }
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
    
        bookListPublish
            .withLatestFrom(state){ list, state -> MapState in
                var newState = state
                newState.listData = list
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        output = Output(state: state.asDriver())
        return output!
    }
    
}

struct MapState{
    var presentVC: PresentVC?
    var viewLogic: ViewLogic?
    var listData: [BookInfo]?
}
