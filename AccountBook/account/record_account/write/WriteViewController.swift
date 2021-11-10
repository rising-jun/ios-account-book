//
//  WriteViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxViewController
import CoreLocation
import MapKit
import RxMKMapView

class WriteViewController: BaseViewController{
    
    lazy var v = WriteView(frame: view.frame)
    private let disposeBag = DisposeBag()
    
    private var permissionCheck: PermissionCheck!
    
    private var locationManager = CLLocationManager()
    private let locStatusSubject = BehaviorSubject<CLAuthorizationStatus>(value: .notDetermined)
    private let coordiSubject = BehaviorSubject<CLLocationCoordinate2D>(value: CLLocationCoordinate2D())
    
    lazy var pointAnnotaion = MKPointAnnotation()
    private var mapViewDelegate = MapViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let viewModel = WriteViewModel()
    lazy var input = WriteViewModel.Input(viewState: self.rx.viewDidLoad.map{ViewState.viewDidLoad},
                                          locState: locStatusSubject.distinctUntilChanged().asObservable(),
                                          coorState: coordiSubject.filter{$0.latitude != 0.0}.asObservable(),
                                          mode: v.setLocModeButton.rx.tap.map{_ in Void()})
    lazy var output = viewModel.bind(input: input)
    
    override func setup() {
        super.setup()
        permissionCheck = PermissionCheck(locationCb: self)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func bindViewModel(){
        super.bindViewModel()
        
        output.state?.map{$0.viewLogic}
        .filter{$0 == .setUpView}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] logic in
            self?.setUpView()
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.categoryData ?? []}
        .distinctUntilChanged()
        .drive(v.categoryPicker.rx.itemTitles){ _, item in
            return item
        }.disposed(by: disposeBag)
        
        output.state?.map{$0.locationPermission ?? .none}
        .filter{$0 != .none}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] status in
            guard let self = self else { return }
            switch status{
            case .gotPermission:
                // map to marking my location
                print(" already have permission ")
                self.locationManager.startUpdatingLocation()
                break
            case .requestPermission:
                self.locationManager.requestWhenInUseAuthorization()
                print(" request to get permission")
                // request Permission
                break
            case .presentSetting:
                // present to setting app
                break
            case .none:
                // nothing to do
                break
            }
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.coordi}
        .drive(onNext: { [weak self] coordi in
            guard let self = self else { return }
            if let coor = coordi{
                self.mapViewInitSet(coordi: coor)
            }
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.locaSetMode}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] mode in
            guard let self = self else { return }
            
            if let mode = mode {
                self.setMapMode(mapMode: mode)
            }
            
        }).disposed(by: disposeBag)
        
        
    }
    
}

extension WriteViewController{
    func setUpView(){
        view = v
        locationManager.delegate = permissionCheck
        permissionCheck.getLocationPermission()
        v.mapView.delegate = mapViewDelegate
    }
    
    func mapViewInitSet(coordi: CLLocationCoordinate2D){
        self.v.mapView.showsUserLocation = true
        self.v.mapView.showsBuildings = true
        self.v.mapView.isPitchEnabled = true
        
        let lat = coordi.latitude
        let long = coordi.longitude
        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        pointAnnotaion.coordinate = coordi
        pointAnnotaion.title = "여기!"
        
        camera.pitch = 80.0
        camera.altitude = 100.0
        self.v.mapView.setCamera(camera, animated: false)
       
        
    }
    
    func setMapMode(mapMode: LocationSetMode){
        if mapMode == .auto{
            self.v.mapView.showsUserLocation = true
            self.v.mapView.removeAnnotation(pointAnnotaion)
        }else{
            self.v.mapView.showsUserLocation = false
            self.v.mapView.addAnnotation(pointAnnotaion)
            
            
        }
    }
    
}

extension WriteViewController: LocationPermissionCallback{
    func getPermission(status: CLAuthorizationStatus) {
        locStatusSubject.onNext(status)
    }
    
    func getPoint(coordinate: CLLocationCoordinate2D) {
        coordiSubject.onNext(coordinate)
    }
    
}
