//
//  ViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

class IntroViewController: BaseViewController, DependencySetable {
    func setDependency(dependency: IntroDependency) {
        self.dependency = dependency
    }
    
    typealias DependencyType = IntroDependency
    override init(){
        super.init()
        DependencyInjector.injecting(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DependencyInjector.injecting(to: self)
    }
    
    private var viewModel: IntroViewModel?
    private var dependency: IntroDependency?{
        didSet{
            self.viewModel = dependency?.viewModel
        }
    }
    private lazy var v = IntroView(frame: view.frame)
    private let disposeBag = DisposeBag()
    
    
    let loginVC = LoginViewController()
    
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
        
        output.state?.map{$0.presentVC ?? .intro}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] presentVC in
            self?.presentVC(vcName: presentVC)
        }).disposed(by: disposeBag)
    }
}

extension IntroViewController{
    
    func setUpView(){
        view = v
        v.animationView.loopMode = .playOnce
        v.animationView.play()
    }
    
    func presentVC(vcName: ViewControllerType){
        if vcName == .login {
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }
    }
}

