//
//  MapViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxSwift
import RxCocoa
import RxViewController
import RxMKMapView
import MapKit

class MapViewController: BaseViewController{
    
    lazy var v = MapView(frame: view.frame)
    private var mapDelegate = MapDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    private let viewModel = MapViewModel()
    private lazy var input = MapViewModel.Input(viewState: rx.viewDidLoad.map{_ in Void()})
    private lazy var output = viewModel.bind(input: input)
    private let disposeBag = DisposeBag()
    
    override func bindViewModel(){
        super.bindViewModel()
        
        
        output.state?.map{$0.viewLogic}
        .filter{$0 == .setUpView}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] logic in
            self?.setUpView()
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.listData ?? []}
        .filter{$0.count > 0}
        .drive(onNext: { [weak self] bookList in
            var paidView = PaidAnnotation(index: 0, latitude: 37.533544, longitude: 127.146997, bookInfo: bookList.first!)
            self?.v.mapView.addAnnotation(paidView)
            
            self!.v.mapView.delegate = self!.mapDelegate
        }).disposed(by: disposeBag)
        
        
    }
    
}

extension MapViewController{
    func setUpView(){
        view = v
        mapViewInitSet(coordi: CLLocationCoordinate2D(latitude: 37.533544, longitude: 127.146997))
        
    }
    
    func mapViewInitSet(coordi: CLLocationCoordinate2D){
        self.v.mapView.showsUserLocation = true
        self.v.mapView.showsBuildings = true
        self.v.mapView.isPitchEnabled = true
        
        let lat = coordi.latitude
        let long = coordi.longitude
        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        
        camera.pitch = 80.0
        camera.altitude = 100.0
        
        self.v.mapView.setCamera(camera, animated: false)
        
    }
    
}
