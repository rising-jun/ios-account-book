//
//  ChartViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import RxSwift
import RxCocoa
import Charts

final class ChartViewController: BaseViewController, DependencySetable{
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
    
    var dependency: DependencyType?{
        didSet{
            viewModel = dependency?.viewModel
        }
    }
    private var viewModel: ChartViewModel?
    private lazy var chartView = ChartView(frame: view.frame)
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
            
            for chart in chartList{
                let entry = PieChartDataEntry(value: chart.value, label: chart.category)
                entryList.append(entry)
            }
            
            let dataSet = PieChartDataSet(entries: entryList, label: "PieChart")
            dataSet.entryLabelColor = UIColor.black
            dataSet.colors = ChartColorTemplates.joyful()
            dataSet.valueColors = [UIColor.black]
            let data = PieChartData(dataSet: dataSet)
            
            self.chartView.pieView.data = data
            self.chartView.pieView.notifyDataSetChanged()
        }).disposed(by: disposeBag)
    }
}

extension ChartViewController{
    private func setUpView(){
        view = chartView
    }
}
