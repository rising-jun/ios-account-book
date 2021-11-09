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

class WriteViewController: BaseViewController{
    
    lazy var v = WriteView(frame: view.frame)
    private let disposeBag = DisposeBag()
    
    private var permissionCheck: PermissionCheck!
    
    private var locationManager = CLLocationManager()
    private let locStatusSubject = BehaviorSubject<CLAuthorizationStatus>(value: .notDetermined)
    private let coordiSubject = BehaviorSubject<CLLocationCoordinate2D>(value: CLLocationCoordinate2D())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let viewModel = WriteViewModel()
    lazy var input = WriteViewModel.Input(viewState: self.rx.viewDidLoad.map{ViewState.viewDidLoad},
                                          locState: locStatusSubject.distinctUntilChanged().asObservable(),
                                          coorState: coordiSubject.filter{$0.latitude != 0.0}.asObservable())
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
                self.mapViewInitSet()
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
        
        
        
        
    }
    
}

extension WriteViewController{
    func setUpView(){
        view = v
        locationManager.delegate = permissionCheck
        permissionCheck.getLocationPermission()
    }
    
    func mapViewInitSet(){
        self.v.mapView.showsUserLocation = true
//        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 2000000)
//        self.v.mapView.setCameraZoomRange(zoomRange, animated: true)
    
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
