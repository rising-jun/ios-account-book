//
//  MapViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import RxSwift
import RxCocoa
import RxAppState
import MapKit

final class MapViewController: BaseViewController, DependencySetable{
    typealias DependencyType = MapDependency
    
    override init(){
        super.init()
        DependencyInjector.injecting(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DependencyInjector.injecting(to: self)
    }
    
    func setDependency(dependency: MapDependency) {
        self.dependency = dependency
    }
    
    var dependency: DependencyType?{
        didSet{
            viewModel = dependency?.viewModel
        }
    }
    private var viewModel: MapViewModel?
    private lazy var mapView = MapView(frame: view.frame)
    private var mapDelegate = MapDelegate()
    private lazy var annotations: [MKPointAnnotation] = []
    private lazy var input = MapViewModel.Input(viewState: rx.viewDidLoad.map{_ in Void()})
    private lazy var output = viewModel?.bind(input: input)
    private let disposeBag = DisposeBag()
    
    override func bindViewModel(){
        super.bindViewModel()
        guard let output = output else { return }
        
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
            self.addAnnotation(to: self.mapView.mapView)
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
        self.mapView.mapView.addAnnotations(annotations)
        self.mapView.mapView.delegate = self.mapDelegate
    }
    
    private func setUpView(){
        view = mapView
        mapViewInitSet(coordi: CLLocationCoordinate2D(latitude: 37.533544, longitude: 127.146997))
        
    }
    
    private func mapViewInitSet(coordi: CLLocationCoordinate2D){
        self.mapView.mapView.showsUserLocation = true
        self.mapView.mapView.showsBuildings = true
        self.mapView.mapView.isPitchEnabled = true
        
        let lat = coordi.latitude
        let long = coordi.longitude
        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        camera.pitch = 80.0
        camera.altitude = 100.0
        self.mapView.mapView.setCamera(camera, animated: false)
    }
}
