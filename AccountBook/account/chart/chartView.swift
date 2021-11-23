//
//  chartView.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/23.
//

import Foundation
import SnapKit
import UIKit

class ChartView: BaseView{
    
    override func setup() {
        super.setup()
        backgroundColor = .white
        
        let width = self.frame.width
        let height = self.frame.height
        
        let pieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        pieChartView.center = self.center
        
        pieChartView.slices = [Slice(percent: 0.4, color: UIColor.systemOrange),
                               Slice(percent: 0.3, color: UIColor.systemTeal),
                               Slice(percent: 0.2, color: UIColor.systemRed),
                               Slice(percent: 0.1, color: UIColor.systemIndigo)]
        
        self.addSubview(pieChartView)
        pieChartView.animateChart()
        
    }
    
}
