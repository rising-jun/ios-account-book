//
//  LoginViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import RxSwift
import RxAppState
import RxGesture

final class LoginViewController: BaseViewController, DependencySetable {
    typealias DependencyType = LoginDependency

    override init(){
        super.init()
        DependencyInjector.injecting(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DependencyInjector.injecting(to: self)
    }
    
    func setDependency(dependency: LoginDependency) {
        self.dependency = dependency
    }
    
    var dependency: LoginDependency?{
        didSet{
            self.viewModel = dependency?.viewModel
        }
    }
    private var viewModel: LoginViewModel?
    private lazy var loginView = LoginView(frame: view.frame)
    private let disposeBag = DisposeBag()
    private lazy var viewControllers = [ListViewController(), MapViewController(), ChartViewController(), MyPageViewController()]
    private lazy var ViewControllerTitles = ["리스트", "맵", "차트", "내정보"]
    
    private lazy var input = LoginViewModel.Input(viewState: rx.viewDidLoad.map{ViewState.viewDidLoad},
                                                  googleLoginTap: self.loginView.googleBtn.rx.tapGesture().skip(1).map{ _ in return Void()} )
    private lazy var output = viewModel?.bind(input: input)
    
    override func bindViewModel(){
        super.bindViewModel()
        guard let output = output else { return }
        output.state?.map{$0.viewLogic}
            .filter{$0 == .setUpView}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] logic in
            self?.setUpView()
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.presentViewController ?? .login}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] presentViewController in
            self?.presentViewController(viewController: presentViewController)
        }).disposed(by: disposeBag)
    }
}
extension LoginViewController{
    private func setUpView(){
        view = loginView
        UIApplication.shared.windows.first?.rootViewController = self
    }
    
    private func presentViewController(viewController: ViewControllerType){
        if viewController == .list{
            let navigationController = UINavigationController()
            let tabBarController = UITabBarController()
            for (index, viewController) in viewControllers.enumerated(){
                tabBarController.addChild(viewController)
                viewController.tabBarItem = UITabBarItem(title: ViewControllerTitles[index], image: UIImage(), tag: index)
            }
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.pushViewController(tabBarController, animated: true)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
