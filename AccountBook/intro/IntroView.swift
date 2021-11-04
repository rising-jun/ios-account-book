//
//  IntroView.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import SnapKit
import UIKit
import Lottie

class IntroView: BaseView{
    
    let animationView = AnimationView(name:"money-lottie")

    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "For Save Money"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func setup() {
        super.setup()
        
        backgroundColor = .cyan
        addSubViews(titleLabel, animationView)
        
        animationView.backgroundColor = .cyan
        animationView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(0)
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.centerX.equalTo(self)
        }
    
    }
}
