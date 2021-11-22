//
//  PaidAnnotation.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/22.
//

import Foundation
import MapKit
import SnapKit
import UIKit

class PaidAnnotationView: MKAnnotationView{
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        clusteringIdentifier = "PaidAnnotationView"
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        backgroundColor = .blue
    
    }
    
}
