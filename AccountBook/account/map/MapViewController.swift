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
    private lazy var annotations: [MKPointAnnotation] = []
    
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
        
        output.state?.map{$0.annotationEntities ?? []}
        .filter{$0.count > 0}
        .drive(onNext: { [weak self] annotationEntities in
            guard let self = self else { return }
            self.makeAnnotationViews(by: annotationEntities)
            self.addAnnotation(to: self.v.mapView)
        }).disposed(by: disposeBag)
    }
    
    private func makeAnnotationViews(by annotationEntities: [PaidAnnotationEntity]){
        let _ = annotationEntities.map{
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = $0.name
            pointAnnotation.subtitle = $0.subTitle
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)
            self.annotations.append(pointAnnotation)
        }
    }
    
    private func addAnnotation(to mapView: MKMapView){
        self.v.mapView.addAnnotations(annotations)
        self.v.mapView.delegate = self.mapDelegate
    }
    
    private func setUpView(){
        view = v
        mapViewInitSet(coordi: CLLocationCoordinate2D(latitude: 37.533544, longitude: 127.146997))
        
    }
    
    private func mapViewInitSet(coordi: CLLocationCoordinate2D){
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
