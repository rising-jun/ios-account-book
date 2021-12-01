//
//  ListView.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import SnapKit
import UIKit

class ListView: BaseView{
    lazy var filterPicker = UIPickerView()
    lazy var tableView = UITableView()
    
    override func setup() {
        super.setup()
        backgroundColor = .white
        
        addSubViews(filterPicker, tableView)
        
        filterPicker.backgroundColor = .white
        filterPicker.snp.makeConstraints { make in
            make.top.equalTo(self).offset(104)
            make.leading.equalTo(self).offset(15)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterPicker.snp.bottom).offset(15)
            make.bottom.equalTo(self).offset(-104)
            make.trailing.equalTo(self).offset(-15)
            make.leading.equalTo(self).offset(15)
        }
        
    }
    
    
}
