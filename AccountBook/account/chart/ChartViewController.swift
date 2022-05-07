//
//  ChartViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxSwift
import RxCocoa
import Charts

class ChartViewController: BaseViewController, DependencySetable{
    
    typealias DependencyType = ChartDependency
    
    override init(){
        super.init()
        DependencyInjector.injecting(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DependencyInjector.injecting(to: self)
    }
    
    func setDependency(dependency: ChartDependency) {
        self.dependency = dependency
    }
    
    private var dependency: ChartDependency?{
        didSet{
            viewModel = dependency?.viewModel
        }
    }
    
    lazy var v = ChartView(frame: view.frame)
    private var viewModel: ChartViewModel?
    private lazy var input = ChartViewModel.Input(viewState: self.rx.viewDidLoad.map{_ in Void()})
    private lazy var output = viewModel?.bind(input: input)
    private let disposeBag = DisposeBag()
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let output = output else { return }
        
        output.state?.map{$0.viewLogic}
        .filter{$0 == .setUpView}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] logic in
            self?.setUpView()
        }).disposed(by: disposeBag)
     
        output.state?.map{$0.chartList ?? []}
        .filter{$0.count > 0}
        .drive(onNext: { [weak self] chartList in
            guard let self = self else { return }
            var entryList: [PieChartDataEntry] = []
            for i in chartList{
                let entry = PieChartDataEntry(value: i.val, label: i.category)
                entryList.append(entry)
            }
            let dataSet = PieChartDataSet(entries: entryList, label: "PieChart")
            dataSet.entryLabelColor = UIColor.black
            dataSet.colors = ChartColorTemplates.joyful()
            dataSet.valueColors = [UIColor.black]
            let data = PieChartData(dataSet: dataSet)
            
            self.v.pieView.data = data
            self.v.pieView.notifyDataSetChanged()
        }).disposed(by: disposeBag)
    }
}

extension ChartViewController{
    func setUpView(){
        view = v
    }
    
    
}
