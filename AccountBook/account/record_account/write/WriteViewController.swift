//
//  WriteViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/08.
//

import RxSwift
import RxCocoa
import RxViewController
import CoreLocation
import MapKit

class WriteViewController: BaseViewController, DependencySetable{
    typealias DependencyType = WriteDependency

    override init(){
        super.init()
        DependencyInjector.injecting(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DependencyInjector.injecting(to: self)
    }
    
    func setDependency(dependency: WriteDependency) {
        self.dependency = dependency
    }
    
    private var viewModel: WriteViewModel?
    var dependency: DependencyType?{
        didSet{
            viewModel = dependency?.viewModel
        }
    }

    private var mapViewDelegate: WriteMapViewDelegate?
    private lazy var writeView = WriteView(frame: view.frame)
    private let disposeBag = DisposeBag()
    private var permissionCheck: PermissionCheck?
    private var locationManager = CLLocationManager()
    private let locationStatusSubject = BehaviorSubject<CLAuthorizationStatus>(value: .notDetermined)
    private let coordiSubject = BehaviorSubject<CLLocationCoordinate2D>(value: CLLocationCoordinate2D())
    private let writeButton = UIBarButtonItem()
    private let backButton = UIBarButtonItem()

    lazy var input = WriteViewModel.Input(viewState: self.rx.viewDidLoad.map{ViewState.viewDidLoad},
                                          locState: locationStatusSubject.distinctUntilChanged().asObservable(),
                                          coorState: coordiSubject.filter{$0.latitude != 0.0}.asObservable(),
                                          mode: writeView.setLocModeButton.rx.tap.map{_ in Void()},
                                          nameInput: writeView.nameTF.rx.text.orEmpty.distinctUntilChanged(),
                                          priceInput: writeView.priceTF.rx.text.orEmpty.distinctUntilChanged(),
                                          categoryInput: writeView.categoryPicker.rx.itemSelected.map{$0.row},
                                          writeAction: writeButton.rx.tap.map{_ in Void()},
                                          dateInput: writeView.datePicker.rx.date.asObservable(),
                                          backAction: backButton.rx.tap.map{ _ in Void()})
    
    lazy var output = viewModel?.bind(input: input)

    override func setup() {
        super.setup()
        permissionCheck = PermissionCheck()
        permissionCheck?.setLocationDelegate(delegate: self)
        mapViewDelegate = WriteMapViewDelegate()
        mapViewDelegate?.setMapDraggedDelegate(from: self)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func bindViewModel(){
        super.bindViewModel()
        guard let output = output else { return }
        output.state?.map{$0.viewLogic}
        .filter{$0 == .setUpView}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] logic in
            self?.setUpView()
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.categoryData ?? []}
        .distinctUntilChanged()
        .drive(writeView.categoryPicker.rx.itemTitles){ _, item in
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
            guard let coor = coordi else { return }
            self.mapViewInitSet(coordi: coor)
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.locaSetMode}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] mode in
            guard let self = self else { return }
            guard let mode = mode else { return }
            self.setMapMode(mapMode: mode)
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.priceformError}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] check in
            guard let self = self else { return }
            check == .possible ? self.writeView.availableUI() : self.writeView.unavailableUI()
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.resultMsg}
        .drive(onNext: { result in
            switch result{
            case .success:
                print("success")
                break
            case .failed:
                print("failed")
                break
            case .none:
                break
            }
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.presentViewController}
        .filter{$0 != .write}
        .drive(onNext: { [weak self] viewController in
            guard let self = self else { return }
            guard let viewController = viewController else { return }
            self.presentViewController(to: viewController)
        }).disposed(by: disposeBag)
    }
}

extension WriteViewController{
    private func setUpView(){
        view = writeView
        locationManager.delegate = permissionCheck
        permissionCheck?.getLocationPermission()
        writeView.mapView.delegate = mapViewDelegate
        setNavigationItemFactor()
    }
    
    private func setNavigationItemFactor(){
        writeButton.title = "작성하기"
        backButton.title = "뒤로가기"
        self.navigationItem.setRightBarButton(self.writeButton, animated: false)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.setLeftBarButton(self.backButton, animated: false)
    }
    
    private func mapViewInitSet(coordi: CLLocationCoordinate2D){
        writeView.mapViewInitSet(coordi: coordi)
    }
    
    private func setMapMode(mapMode: LocationSetMode){
        writeView.setMapMode(mapMode: mapMode)
    }
    
    private func presentViewController(to viewController: ViewControllerType){
        if viewController == .list{
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension WriteViewController: PermissionDelegate, MapDraggedDelegate{
    func draggedPoint(coordi: CLLocationCoordinate2D) {
        coordiSubject.onNext(coordi)
    }
    
    func getPermission(status: CLAuthorizationStatus) {
        locationStatusSubject.onNext(status)
    }
    
    func getPoint(coordinate: CLLocationCoordinate2D) {
        coordiSubject.onNext(coordinate)
    }
}
