//
//  WriteViewController.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/08.
//

import Foundation
import RxCocoa
import RxSwift
import RxViewController
import CoreLocation

class WriteViewController: BaseViewController{
    
    lazy var v = WriteView(frame: view.frame)
    private let disposeBag = DisposeBag()
    private var locationPublish = PublishSubject<CLAuthorizationStatus>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let viewModel = WriteViewModel()
    lazy var input = WriteViewModel.Input(viewState: self.rx.viewDidLoad.map{ViewState.viewDidLoad},
                                          locationStatus: locationPublish.asObserver())
    lazy var output = viewModel.bind(input: input)
    
    override func setup() {
        super.setup()
        let callback: LocationPermissionCallback = self
        let permissionCheck = PermissionCheck(locationCb: callback)
        permissionCheck.getLocationPermission()
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
    
        
        
        
    }
    
}

extension WriteViewController{
    func setUpView(){
        view = v
    }
}

extension WriteViewController: LocationPermissionCallback{
    func getPermission(status: CLAuthorizationStatus) {
        locationPublish.onNext(status)
    }
    
    
}
