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
        
        if compose is WriteViewController{
            guard let viewController = compose as? WriteViewController else { return }
            viewController.setDependency(dependency: WriteDependency(viewModel: WriteViewModel(firebaseWriteable: FirebaseWriteRepository(), writeExpressionCheckable: RegularExpression())))
        }
        
        if compose is ListViewController{
            guard let viewController = compose as? ListViewController else { return }
            viewController.setDependency(dependency: ListDependency(viewModel: ListViewModel(firebaseReadable: FirebaseReadRepository())))
        }
        
        if compose is MapViewController{
            guard let viewController = compose as? MapViewController else { return }
            viewController.setDependency(dependency: MapDependency(viewModel: MapViewModel(firebaseReadable: FirebaseReadRepository())))
        }
        
        if compose is ChartViewController{
            guard let viewController = compose as? ChartViewController else { return }
            viewController.setDependency(dependency: ChartDependency(viewModel: ChartViewModel(firebaseReadable: FirebaseReadRepository())))
        }
        
        if compose is MyPageViewController{
            guard let viewController = compose as? MyPageViewController else { return }
            viewController.setDependency(dependency: MyPageDependency(viewModel: MyPageViewModel(firebaseReadable: FirebaseReadRepository())))
        }
    }
}

protocol DependencySetable{
    associatedtype DependencyType
    func setDependency(dependency: DependencyType)
    var dependency: DependencyType? { get set }
}

protocol Dependency{
    associatedtype ViewModelType
}


