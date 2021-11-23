//
//  MapView.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/18.
//

import Foundation
import SnapKit
import UIKit
import MapKit

class MapView: BaseView{
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        return mapView
    }()
    
    override func setup() {
        super.setup()
        backgroundColor = .white
        
        addSubViews(mapView)
        
        mapView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo(400)
            make.height.equalTo(600)
            make.bottom.equalTo(self).offset(-120)
        }
        
    }
    
}
