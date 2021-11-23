//
//  ChartViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxSwift
import RxCocoa

class ChartViewController: BaseViewController{
    
    lazy var v = ChartView(frame: view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
    
    
    private let viewModel = ChartViewModel()
    private lazy var input = ChartViewModel.Input(viewState: self.rx.viewDidLoad.map{_ in Void()})
    private lazy var output = viewModel.bind(input: input)
    private let disposeBag = DisposeBag()
    
    override func bindViewModel() {
        super.bindViewModel()
        
        output.state?.map{$0.viewLogic}
        .filter{$0 == .setUpView}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] logic in
            self?.setUpView()
        }).disposed(by: disposeBag)
        
    }
    
}

extension ChartViewController{
    func setUpView(){
        view = v
    }
}
