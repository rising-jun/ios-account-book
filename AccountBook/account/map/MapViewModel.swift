//
//  MapViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/18.
//

import RxSwift
import RxCocoa

final class MapViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<MapState>(value: MapState())
    private let disposeBag = DisposeBag()
    private var firebaseReadable: FirebaseReadable?
    private var bookListPublish = PublishSubject<[BookInfo]>()
    
    init(firebaseReadable: FirebaseReadable){
        self.firebaseReadable = firebaseReadable
    }
    
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
                guard let self = self else { return state }
                var newState = state
                newState.viewLogic = .setUpView
                self.firebaseReadable?.readBookInfo { result in
                    self.updateBooks(result: result)
                }
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
    
        bookListPublish
            .withLatestFrom(state){ list, state -> MapState in
                var newState = state
                if newState.annotationEntities == nil{
                    newState.annotationEntities = []
                }
                var entities = newState.annotationEntities
                let _ = list.map{entities?.append(PaidAnnotationEntity(name: $0.name, subTitle: $0.price, lat: $0.lat, long: $0.long))}
                newState.annotationEntities = entities
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        return Output(state: state.asDriver())
    }
    
}

extension MapViewModel{
    private func updateBooks(result: Result<[BookInfo], FireBaseError>){
        switch result{
        case .success(let books):
            bookListPublish.onNext(books)
        case .failure(let error):
            print(error)
        }
    }
}
struct MapState{
    var presentViewController: ViewControllerType?
    var viewLogic: ViewLogic?
    var annotationEntities: [PaidAnnotationEntity]?
}
