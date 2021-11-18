//
//  MapViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation

class MapViewController: BaseViewController{
    
    lazy var v = MapView(frame: view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = v
    }
}
