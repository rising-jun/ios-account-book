//
//  LoginView.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import UIKit
import SnapKit
import GoogleSignIn

final class LoginView: BaseView{
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "SNS 로그인을 사용해주세요."
        label.textColor = .magenta
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var googleBtn = GIDSignInButton()

    override func setup() {
        backgroundColor = .cyan
        addSubViews(titleLabel, googleBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(100)
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.centerX.equalTo(self)
        }
        
        googleBtn.style = .wide
        googleBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-80)
            make.leading.equalTo(self).offset(30)
            make.trailing.equalTo(self).offset(-30)
            make.height.equalTo(50)
        }
    
        
        
        
    }
    
    
    
}
