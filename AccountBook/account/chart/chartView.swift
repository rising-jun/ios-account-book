//
//  chartView.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/23.
//


import SnapKit
import Charts

final class ChartView: BaseView{
    lazy var pieView = PieChartView()
    
    override func setup() {
        super.setup()
        backgroundColor = .white
        addSubViews(pieView)
        pieView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(600)
        }
    }
}
