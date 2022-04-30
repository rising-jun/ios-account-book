//
//  ChartViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/23.
//

import Foundation
import RxSwift
import RxCocoa

class ChartViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<ChartState>(value: ChartState())
    private let disposeBag = DisposeBag()
    
    private var fbReadModel: FirebaseReadRepository!
    
    private var bookListPublish = PublishSubject<[ChartInfo]>()
    
    
    struct Input{
        let viewState: Observable<Void>?
        
    }
    
    struct Output{
        var state: Driver<ChartState>?
    }
    
    func bind(input: Input) -> Output{
        self.input = input
        //fbReadModel = FirebaseReadRepository(fbCallBack: self)
        
        input.viewState?
            .withLatestFrom(state){ [weak self] _, state -> ChartState in
                var newState = state
                newState.viewLogic = .setUpView
                self!.fbReadModel.readBookInfo { result in
                    self!.bookInfoList(result: result)
                }
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
    
        bookListPublish
            .withLatestFrom(state){ list, state -> ChartState in
                var newState = state
                print("get list successly")
                newState.chartList = list
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        output = Output(state: state.asDriver())
        return output!
    }
    
}

struct ChartState{
    var presentVC: PresentVC?
    var viewLogic: ViewLogic?
    var chartList: [ChartInfo]?
}

extension ChartViewModel{
    func bookInfoList(result: Result<[BookInfo], FireBaseError>) {
        switch result{
        case .success(let books):
            bookListPublish.onNext(convertChartList(books))
        case .failure(let error):
            print(error)
        }
       
    }
    
    func categoryColor(_ category: String) -> UIColor{
        
        switch category{
        case "생활비":
            return .blue
            break
        case "유흥비":
            return .black
        case "식비":
            return .brown
            break
        default:
            return .darkGray
        }
        
    }
    
    func convertChartList(_ bookList: [BookInfo]) -> [ChartInfo]{
        var chartList: [ChartInfo] = [ChartInfo(category: "생활비", per: 0.0, val: 0),ChartInfo(category: "유흥비", per: 0.0, val: 0),ChartInfo(category: "식비", per: 0.0, val: 0)]
        
        for i in bookList{
            switch i.category{
            case "생활비":
                chartList[0].val += Double(i.price) ?? 0.0
                break
            case "유흥비":
                chartList[1].val += Double(i.price) ?? 0.0
                break
            case "식비":
                chartList[2].val += Double(i.price) ?? 0.0
                break
            default:
                break
            }
        }
        
        return chartList
    }
    
    
}
