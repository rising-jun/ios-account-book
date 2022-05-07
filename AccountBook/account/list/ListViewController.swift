//
//  ListViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxViewController
import RxDataSources

class ListViewController: BaseViewController, DependencySetable{
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
    lazy var v = ListView(frame: view.frame)
    lazy var myInfoBtn = UIBarButtonItem()
    private var dataSource: RxTableViewSectionedReloadDataSource<MySection>!
    private var delegate: BookTableDelegate?
    private lazy var input = ListViewModel.Input(viewState: rx.viewDidLoad.map{_ in Void()},
                                                 writeTouch: myInfoBtn.rx.tap.map{ _ in Void()},
                                                 returnListView: rx.viewWillAppear.map{_ in Void()})
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
        .drive(v.filterPicker.rx.itemTitles){_, item in
            return "\(item)"
        }.disposed(by: disposeBag)
        
        output.state?.map{$0.listData ?? []}
        .filter{$0.count > 0}
        .map{[MySection(header: "a", items: $0)]}
        .drive(v.tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        output.state?.map{$0.presentVC ?? .list}
            .distinctUntilChanged()
            .drive(onNext: { [weak self] presentVC in
            self?.presentVC(vcName: presentVC)
        }).disposed(by: disposeBag)
    }
    
    override func setup() {
        super.setup()
        v.tableView.register(BookTableCell.self, forCellReuseIdentifier: "BookTableCell")
        dataSource = RxTableViewSectionedReloadDataSource<MySection>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableCell", for: indexPath) as! BookTableCell
                cell.priceLabel.text = item.price
                cell.titleLabel.text = item.name
                cell.categoryLabel.text = item.category
                cell.dateLabel.text = "12"
                return cell
            })
    }
    
}

extension ListViewController{
    
    func setUpView(){
        view = v
        view.backgroundColor = .white
        self.myInfoBtn.title = "작성하기"
        self.tabBarController?.navigationItem.setRightBarButton(self.myInfoBtn, animated: false)
    }
    
    func presentVC(vcName: ViewControllerType){
        if vcName == .write{
            let writeVC = WriteViewController()
            self.navigationController?.pushViewController(writeVC, animated: true)
        }
    }
}

struct ListDependency: Dependency{
    typealias ViewModelType = ListViewModel
    let viewModel: ListViewModel
}
