//
//  ListViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import RxSwift
import RxCocoa
import FirebaseFirestore
import RxAppState

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
        let viewState: Observable<ViewControllerViewState>?
        var writeTouch: Observable<Void>?
        //var returnListView: Observable<Bool>?
    }
    
    struct Output{
        var state: Driver<ListViewState>?
    }
    
    private let disposeBag = DisposeBag()
    
    func bind(input: Input) -> Output{
        self.input = input
        
        input.viewState?
            .withLatestFrom(state){ viewLife, state -> ListViewState in
                var newState = state
                if viewLife == .viewDidLoad{
                    newState.viewLogic = .setUpView
                    newState.filterData = ["높은금액순", "최신순", "카테고리 별"]
                    self.firebaseReadable.readBookInfo(completion: { result in
                        self.bookInfoList(result: result)
                    })
                }
                
                if viewLife == .viewWillDisappear{
                    newState.presentViewController = .list
                    self.firebaseReadable.readBookInfo(completion: { result in
                        self.bookInfoList(result: result)
                    })
                }
                return newState
            }
            .bind(to: self.state)
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
