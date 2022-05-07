//
//  ChartViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/23.
//

import RxSwift
import RxCocoa

final class ChartViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<ChartState>(value: ChartState())
    private let disposeBag = DisposeBag()
    private var firebaseReadable: FirebaseReadable?
    private var bookListPublish = PublishSubject<[ChartInfo]>()
    
    init(firebaseReadable: FirebaseReadable){
        self.firebaseReadable = firebaseReadable
    }
    
    struct Input{
        let viewState: Observable<Void>?
    }
    
    struct Output{
        var state: Driver<ChartState>?
    }
    
    func bind(input: Input) -> Output{
        self.input = input
        input.viewState?
            .withLatestFrom(state){ [weak self] _, state -> ChartState in
                guard let self = self else { return state }
                var newState = state
                newState.viewLogic = .setUpView
                self.firebaseReadable?.readBookInfo { result in
                    self.bookInfoList(result: result)
                }
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
    
        bookListPublish
            .withLatestFrom(state){ list, state -> ChartState in
                var newState = state
                newState.chartList = list
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        return Output(state: state.asDriver())
    }
    
}

struct ChartState{
    var presentViewController: ViewControllerType?
    var viewLogic: ViewLogic?
    var chartList: [ChartInfo]?
}

extension ChartViewModel{
    private func bookInfoList(result: Result<[BookInfo], FireBaseError>) {
        switch result{
        case .success(let books):
            bookListPublish.onNext(convertChartList(from: books))
        case .failure(let error):
            print(error)
        }
    }
    
    private func categoryColor(_ category: String) -> UIColor{
        switch category{
        case "생활비":
            return .blue
        case "유흥비":
            return .black
        case "식비":
            return .brown
        default:
            return .darkGray
        }
    }
    
    private func convertChartList(from bookList: [BookInfo]) -> [ChartInfo]{
        let chartList: [ChartInfo] = [ChartInfo(category: "생활비", percent: 0.0, value: 0),ChartInfo(category: "유흥비", percent: 0.0, value: 0),ChartInfo(category: "식비", percent: 0.0, value: 0)]
        for book in bookList{
            guard let price = Double(book.price) else { return [] }
            switch book.category{
            case "생활비":
                let value = chartList[0].value
                chartList[0].setValue(value: value + price)
                break
            case "유흥비":
                let value = chartList[1].value
                chartList[1].setValue(value: value + price)
                break
            case "식비":
                let value = chartList[2].value
                chartList[2].setValue(value: value + price)
                break
            default:
                break
            }
        }
        return chartList
    }
}
