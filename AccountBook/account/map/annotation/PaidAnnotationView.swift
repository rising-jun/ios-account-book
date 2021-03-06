//
//  PaidAnnotation.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/22.
//

import MapKit
import SnapKit

final class PaidAnnotationView: MKAnnotationView{
    
    private lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.text = "상호명"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
       let label = UILabel()
        label.text = "상호명"
        label.textAlignment = .center
        return label
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(100)
        }

        clusteringIdentifier = "PaidAnnotationView"
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubViews(nameLabel, priceLabel)
        
        nameLabel.text = "name!"
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(5)
            make.centerX.equalTo(self)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalTo(self)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
}
