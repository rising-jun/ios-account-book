//
//  DependencyInjector.swift
//  AccountBook
//
//  Created by 김동준 on 2022/05/01.
//

import Foundation

final class DependencyInjector{
    static func injecting(to compose: DependencySetable){
        if compose is IntroViewController{
            compose.setDependency(dependency: IntroDependency(viewModel: IntroViewModel(timer: Timer(timerSec: 3))))
        }
        
    }
}

protocol DependencySetable{
    func setDependency(dependency: Dependency)
}

protocol Dependency{
}


