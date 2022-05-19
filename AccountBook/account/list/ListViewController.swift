//
//  ListViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import RxSwift
import RxCocoa
import RxAppState
import RxDataSources

final class ListViewController: BaseViewController, DependencySetable{
    typealias DependencyType = ListDependency
    
    override init(){
        super.init()
        DependencyInjector.injecting(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DependencyInjector.injecting(to: self)
    }
    
    func setDependency(dependency: ListDependency) {
        self.dependency = dependency
    }
    
    var dependency: DependencyType?{
        didSet{
            self.viewModel = dependency?.viewModel
        }
    }
    private var viewModel: ListViewModel?
    private lazy var listView = ListView(frame: view.frame)
    private lazy var myInfoButton = UIBarButtonItem()
    private var dataSource = RxTableViewSectionedReloadDataSource<MySection>(
        configureCell: { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableCell", for: indexPath) as? BookTableCell else { return UITableViewCell() }
            cell.setCellInfo(from: item)
            return cell
        })
    
    private var delegate: BookTableDelegate?
    private lazy var input = ListViewModel.Input(
        viewState: rx.viewState.asObservable(),
        writeTouch: myInfoButton.rx.tap.map{ _ in Void()})
    private lazy var output = viewModel?.bind(input: input)
    private let disposeBag = DisposeBag()
    
    override func bindViewModel(){
        super.bindViewModel()
        guard let output = output else { return }
        
        output.state?.map{$0.viewLogic}
        .filter{$0 == .setUpView}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] logic in
            self?.setUpView()
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.filterData ?? []}
        .distinctUntilChanged()
        .drive(listView.filterPicker.rx.itemTitles){_, item in
            return "\(item)"
        }.disposed(by: disposeBag)
        
        output.state?.map{$0.listData ?? []}
        .filter{$0.count > 0}
        .map{[MySection(header: "a", items: $0)]}
        .drive(listView.tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        output.state?.map{$0.presentViewController ?? .list}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] presentViewController in
            self?.presentViewController(viewController: presentViewController)
        }).disposed(by: disposeBag)
    }
    
    override func setup() {
        super.setup()
        listView.tableView.register(BookTableCell.self, forCellReuseIdentifier: BookTableCell.identifier)
    }
}

extension ListViewController{
    
    private func setUpView(){
        view = listView
        view.backgroundColor = .white
        self.myInfoButton.title = "작성하기"
        self.tabBarController?.navigationItem.setRightBarButton(self.myInfoButton, animated: false)
    }
    
    private func presentViewController(viewController: ViewControllerType){
        if viewController == .write{
            let writeViewController = WriteViewController()
            self.navigationController?.pushViewController(writeViewController, animated: true)
        }
    }
}

enum ViewLifeCycle{
    case viewDidLoad
    case viewDidLayoutSubviews
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
}
