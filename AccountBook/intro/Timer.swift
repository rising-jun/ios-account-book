//
//  Timer.swift
//  AccountBook
//
//  Created by 김동준 on 2022/05/01.
//

import RxSwift

struct Timer{
    private var animationTimer: Observable<Int>?
    private let disposeBag = DisposeBag()
    
    init(timerSec: Int){
        self.animationTimer = Observable<Int>.interval(.seconds(timerSec), scheduler: MainScheduler.instance).take(1)
    }
}

extension Timer: TimerUsable{
    func timerStart(completion: @escaping(Result<Void, TimerError>) -> Void) {
        animationTimer?.subscribe(onNext: { _ in
            completion(.success(()))
        }, onError: { error in
            completion(.failure(.timerError))
        }).disposed(by: disposeBag)
    }
}

protocol TimerUsable{
    func timerStart(completion: @escaping(Result<Void, TimerError>) -> Void)
}

enum TimerError: Error{
    case timerError
}
