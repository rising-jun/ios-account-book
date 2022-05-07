//
//  ViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import RxSwift
import RxCocoa
import RxViewController

final class IntroViewController: BaseViewController, DependencySetable {
    typealias DependencyType = IntroDependency
    
    override init(){
        super.init()
        DependencyInjector.injecting(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DependencyInjector.injecting(to: self)
    }
    
    func setDependency(dependency: IntroDependency) {
        self.dependency = dependency
    }
    
    var dependency: DependencyType?{
        didSet{
            self.viewModel = dependency?.viewModel
        }
    }
    private var viewModel: IntroViewModel?
    private lazy var introView = IntroView(frame: view.frame)
    private let disposeBag = DisposeBag()
    private lazy var input = IntroViewModel.Input(viewState: rx.viewDidLoad.map{ViewState.viewDidLoad})
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
        
        output.state?.map{$0.presentViewController ?? .intro}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] presentViewController in
            self?.presentViewController(viewController: presentViewController)
        }).disposed(by: disposeBag)
    }
}

extension IntroViewController{
    private func setUpView(){
        view = introView
        introView.animationView.loopMode = .playOnce
        introView.animationView.play()
    }
    
    private func presentViewController(viewController: ViewControllerType){
        lazy var loginViewController = LoginViewController()
        if viewController == .login {
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true, completion: nil)
        }
    }
}

