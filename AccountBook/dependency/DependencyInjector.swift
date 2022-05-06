//
//  DependencyInjector.swift
//  AccountBook
//
//  Created by 김동준 on 2022/05/01.
//

import Foundation

final class DependencyInjector{
    static func injecting<T: DependencySetable>(to compose: T){
        if compose is IntroViewController{
            guard let viewController = compose as? IntroViewController else { return }
            viewController.setDependency(dependency: IntroDependency(viewModel: IntroViewModel(timer: Timer(timerSec: 3))))
        }
        if compose is LoginViewController{
            guard let viewController = compose as? LoginViewController else { return }
            viewController.setDependency(dependency: LoginDependency(viewModel: LoginViewModel(googleLoginable: GoogleLoginToken())))
        }
    }
}

protocol DependencySetable{
    associatedtype DependencyType
    func setDependency(dependency: DependencyType)
}

protocol Dependency{
    associatedtype ViewModelType
}


