//
//  MyPageViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxSwift
import RxCocoa
import RxViewController

class MyPageViewController: BaseViewController{
    
    lazy var v = MyPageView(frame: view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = MyPageViewModel()
    private lazy var input = MyPageViewModel.Input(viewState: self.rx.viewDidLoad.map{_ in Void()})
    private lazy var output = viewModel.bind(input: input)
    
    override func bindViewModel() {
        super.bindViewModel()
        output.state?.map{$0.viewLogic}
        .filter{$0 == .setUpView}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] logic in
            self?.setUpView()
        }).disposed(by: disposeBag)
    
        output.state?.map{$0.paySum ?? 0}
        .filter{$0 > 0}
        .distinctUntilChanged()
        .map{String($0)}
        .drive(v.sumValLabel.rx.text)
        .disposed(by: disposeBag)
    
    }
    
    
    
    
}

extension MyPageViewController{
    func setUpView(){
        view = v
    }
}
