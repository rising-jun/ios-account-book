//
//  ListViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import RxSwift
import RxCocoa

final class ListViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<ListViewState>(value: ListViewState())
    private var listData = PublishSubject<[BookInfo]>()
    private var firebaseReadable: FirebaseReadable
    
    init(firebaseReadable: FirebaseReadable){
        self.firebaseReadable = firebaseReadable
    }
    
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
                guard let self = self else { return state }
                var newState = state
                newState.viewLogic = .setUpView
                newState.filterData = ["높은금액순", "최신순", "카테고리 별"]
                self.firebaseReadable.readBookInfo(completion: { result in
                    self.bookInfoList(result: result)
                })
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.writeTouch?
            .withLatestFrom(state)
            .map{ state -> ListViewState in
                var newState = state
                newState.presentViewController = .write
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
                guard let self = self else { return state }
                var newState = state
                newState.presentViewController = .list
                self.firebaseReadable.readBookInfo(completion: { result in
                    self.bookInfoList(result: result)
                })
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        return Output(state: state.asDriver())
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
    var presentViewController: ViewControllerType?
    var viewLogic: ViewLogic?
    var filterData: [String]?
    var listData: [BookInfo]?
}
