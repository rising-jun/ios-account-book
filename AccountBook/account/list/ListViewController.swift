//
//  ListViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import UIKit
import RxSwift
import RxViewController

class ListViewController: BaseViewController{
    
    lazy var myInfoBtn = UIBarButtonItem()
    lazy var v = ListView(frame: view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    private let viewModel = ListViewModel()
    private lazy var input = ListViewModel.Input(viewState: rx.viewDidLoad.map{ViewState.viewDidLoad})
    private lazy var output = viewModel.bind(input: input)
    private let disposeBag = DisposeBag()
    
    override func bindViewModel(){
        super.bindViewModel()
        
        output.state?.map{$0.viewLogic}
            .filter{$0 == .setUpView}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] logic in
            self?.setUpView()
        }).disposed(by: disposeBag)
        
        
        
    }
    
}

extension ListViewController{
    func setUpView(){
        view = v
        view.backgroundColor = .white
        self.myInfoBtn.title = "나의카드"
        self.navigationItem.setRightBarButton(self.myInfoBtn, animated: false)
    }
}
