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

class IntroViewController: BaseViewController {
    
    lazy var v = IntroView(frame: view.frame)
    lazy var viewModel = IntroViewModel()
    private let disposeBag = DisposeBag()
    
    let loginVC = LoginViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    lazy var input = IntroViewModel.Input(viewState: rx.viewDidLoad.map{ViewState.viewDidLoad})
    lazy var output = viewModel.bind(input: input)
    
    
    override func bindViewModel(){
        super.bindViewModel()
        
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
    
    func presentVC(vcName: PresentVC){
        if vcName == .login {
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }
        
    }
    
}

