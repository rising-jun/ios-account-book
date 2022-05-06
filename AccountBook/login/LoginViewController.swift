//
//  LoginViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxSwift
import RxViewController
import RxGesture

final class LoginViewController: BaseViewController, DependencySetable {
    func setDependency(dependency: LoginDependency) {
        self.dependency = dependency
    }
    
    typealias DependencyType = LoginDependency
    
    override init(){
        super.init()
        DependencyInjector.injecting(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DependencyInjector.injecting(to: self)
    }
    
    lazy var v = LoginView(frame: view.frame)
    private var viewModel: LoginViewModel?
    private var dependency: LoginDependency?{
        didSet{
            self.viewModel = dependency?.viewModel
        }
    }
    
    private let disposeBag = DisposeBag()
    let nav = UINavigationController()
    lazy var vcArr = [ListViewController(), MapViewController(), ChartViewController(), MyPageViewController()]
    lazy var vcNameArr = ["리스트", "맵", "차트", "내정보"]
    
    private lazy var input = LoginViewModel.Input(viewState: rx.viewDidLoad.map{ViewState.viewDidLoad},
                                                  googleLoginTap: self.v.googleBtn.rx.tapGesture().skip(1).map{ _ in return Void()} )
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
        
        output.state?.map{$0.presentVC ?? .login}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] presentVC in
            self?.presentVC(vcName: presentVC)
        }).disposed(by: disposeBag)
    }
}
extension LoginViewController{
    
    func setUpView(){
        view = v
        UIApplication.shared.windows.first?.rootViewController = self
    }
    
    func presentVC(vcName: PresentVC){
        
        if vcName == .list{
            let nav = UINavigationController()
            let tabBar = UITabBarController()
            for i in 0 ..< vcArr.count{
                tabBar.addChild(vcArr[i])
                vcArr[i].tabBarItem = UITabBarItem(title: vcNameArr[i], image: UIImage(), tag: i)
            }
            nav.modalPresentationStyle = .fullScreen
            nav.pushViewController(tabBar, animated: true)
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
}
