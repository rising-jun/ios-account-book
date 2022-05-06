//
//  ListViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

class ListViewModel{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<ListViewState>(value: ListViewState())
    private var listData = PublishSubject<[BookInfo]>()
    
    private var fbModel = FirebaseReadRepository()
    
    struct Input{
        let viewState: Observable<Void>?
        let writeTouch: Observable<Void>?
        let returnListView: Observable<Void>?
    }
    
    struct Output{
        var state: Driver<ListViewState>?
    }
    
    private let disposeBag = DisposeBag()
    
    func bind(input: Input) -> Output{
        self.input = input
        
        input.viewState?
            .withLatestFrom(state)
            .map{[weak self] state -> ListViewState in
                var newState = state
                newState.viewLogic = .setUpView
                newState.filterData = ["높은금액순", "최신순", "카테고리 별"]
                self?.fbModel.readBookInfo(completion: { result in
                    self?.bookInfoList(result: result)
                })
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.writeTouch?
            .withLatestFrom(state)
            .map{ state -> ListViewState in
                var newState = state
                newState.presentVC = .write
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        listData.withLatestFrom(state){ list, state -> ListViewState in
            var newState = state
            newState.listData = list
            return newState
        }.bind(to: self.state)
        .disposed(by: disposeBag)
        
        input.returnListView?
            .withLatestFrom(state)
            .map{ [weak self] state -> ListViewState in
                var newState = state
                newState.presentVC = .list
                self?.fbModel.readBookInfo(completion: { result in
                    self?.bookInfoList(result: result)
                })
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        
        output = Output(state: state.asDriver())
        return output!
    }
}

extension ListViewModel{
    func bookInfoList(result: Result<[BookInfo], FireBaseError>) {
        switch result{
        case .success(let bookList):
            listData.onNext(bookList)
        case .failure(let error):
            print(error)
        }
    }
}

struct ListViewState{
    var presentVC: ViewControllerType?
    var viewLogic: ViewLogic?
    var filterData: [String]?
    var listData: [BookInfo]?
}
