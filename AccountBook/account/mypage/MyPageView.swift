//
//  MyPageView.swift
//  AccountBook
//
//  Created by 김동준 on 2021/12/01.
//

import Foundation
import UIKit
import SnapKit

class MyPageView: BaseView{
    
    lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.text = "총 사용금액"
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var sumValLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    
    override func setup() {
        super.setup()
        backgroundColor = .white
    
        addSubViews(sumLabel, sumValLabel)
        sumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.width.equalTo(130)
            make.height.equalTo(40)
            make.leading.equalTo(70)
        }
        
        sumValLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(sumLabel.snp.trailing).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        
    }
    
    
}
