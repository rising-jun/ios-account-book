//
//  WriteView.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/08.
//

import Foundation
import SnapKit
import UIKit
import MapKit

class WriteView: BaseView{
    
    lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.text = "상호명"
        label.textAlignment = .center
        return label
    }()
    
    lazy var nameTF: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.layer.addBorder(edge: .bottom, color: .black, thickness: 2.0)
        return tf
    }()
    
    lazy var priceLabel: UILabel = {
       let label = UILabel()
        label.text = "금액"
        label.textAlignment = .center
        return label
    }()
    
    lazy var priceTF: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.layer.addBorder(edge: .bottom, color: .black, thickness: 2.0)
        return tf
    }()
    
    lazy var categoryLabel: UILabel = {
       let label = UILabel()
        label.text = "카테고리"
        label.textAlignment = .center
        return label
    }()
    
    lazy var categoryPicker = UIPickerView()
    
    lazy var dateLabel: UILabel = {
       let label = UILabel()
        label.text = "시용일자"
        label.textAlignment = .center
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    lazy var mapLabel: UILabel = {
       let label = UILabel()
        label.text = "위치"
        label.textAlignment = .center
        return label
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        return mapView
    }()
    
    override func setup() {
        super.setup()
        backgroundColor = .white
        
        addSubViews(nameLabel, nameTF, priceLabel, priceTF, categoryLabel, categoryPicker, dateLabel, datePicker, mapLabel, mapView)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(104)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        
        nameTF.snp.makeConstraints { make in
            make.top.equalTo(self).offset(104)
            make.leading.equalTo(nameLabel.snp.trailing).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(40)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        
        priceTF.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.leading.equalTo(priceLabel.snp.trailing).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(40)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        
        categoryPicker.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.leading.equalTo(categoryLabel.snp.trailing).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(60)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(20)
            make.leading.equalTo(dateLabel.snp.trailing).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(60)
        }
        
        mapLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(mapLabel.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(300)
        }
        
        
    }
    
}
