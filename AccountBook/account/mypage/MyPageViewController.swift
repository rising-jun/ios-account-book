//
//  MyPageViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import RxSwift
import RxCocoa
import RxViewController

final class MyPageViewController: BaseViewController, DependencySetable{
    typealias DependencyType = MyPageDependency
    
    override init(){
        super.init()
        DependencyInjector.injecting(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DependencyInjector.injecting(to: self)
    }
    
    func setDependency(dependency: MyPageDependency) {
        self.dependency = dependency
    }
    
    var dependency: MyPageDependency?{
        didSet{
            viewModel = dependency?.viewModel
        }
    }
    private var viewModel: MyPageViewModel?
    private lazy var myPageView = MyPageView(frame: view.frame)
    private let disposeBag = DisposeBag()
    private lazy var input = MyPageViewModel.Input(viewState: self.rx.viewDidLoad.map{_ in Void()})
    private lazy var output = viewModel?.bind(input: input)
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let output = output else { return }
        
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
        .drive(myPageView.sumValLabel.rx.text)
        .disposed(by: disposeBag)
    }
}

extension MyPageViewController{
    func setUpView(){
        view = myPageView
    }
}
