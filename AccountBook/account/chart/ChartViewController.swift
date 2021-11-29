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
            dataSet.colors = ChartColorTemplates.joyful()
            dataSet.valueColors = [UIColor.black]
            let data = PieChartData(dataSet: dataSet)
            
            self.v.pieView.data = data
            //All other additions to this function will go here

            //This must stay at end of function
            self.v.pieView.notifyDataSetChanged()
        }).disposed(by: disposeBag)
        
        
    }
    
}

extension ChartViewController{
    func setUpView(){
        view = v
    }
    
    
}
