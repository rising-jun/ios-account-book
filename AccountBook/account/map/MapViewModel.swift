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
    
    private var fbReadModel: FirebaseReadModel!
    
    
    struct Input{
        let viewState: Observable<Void>?
        
    }
    
    struct Output{
        var state: Driver<MapState>?
    }
    
    func bind(input: Input) -> Output{
        self.input = input
        fbReadModel = FirebaseReadModel(fbCallBack: self)
        
        input.viewState?
            .withLatestFrom(state){ _, state -> MapState in
                var newState = state
                newState.viewLogic = .setUpView
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

extension MapViewModel: FirebaseReadProtocol{
    func bookInfoList(bookList: [BookInfo]) {
        
    }
    
    
}
