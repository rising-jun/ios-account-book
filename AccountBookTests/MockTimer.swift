//
//  MockTimer.swift
//  AccountBookTests
//
//  Created by 김동준 on 2022/05/14.
//

import Foundation
@testable import AccountBook

struct MockTimer: TimerUsable{
    private let timerSec: Int
    init(timerSec: Int){
        self.timerSec = timerSec
        print("mocktime init")
    }
    func timerStart(completion: @escaping (Result<Void, TimerError>) -> Void) {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(timerSec), repeats: true) { _ in
            print("mocktime over")
        }
    }
}
