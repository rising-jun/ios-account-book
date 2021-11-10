//
//  WriteViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/08.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class WriteViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<WriteState>(value: WriteState())
    
    struct Input{
        let viewState: Observable<ViewState>?
        let locState: Observable<CLAuthorizationStatus>?
        let coorState: Observable<CLLocationCoordinate2D>?
        let mode: Observable<Void>?
    }
    
    struct Output{
        var state: Driver<WriteState>?
    }
    
    private let disposeBag = DisposeBag()
    
    func bind(input: Input) -> Output{
        self.input = input
        
        
        input.locState?
            .withLatestFrom(state){ locStatus, state -> WriteState in
                var newState = state
                switch locStatus{
                case .authorizedAlways, .authorizedWhenInUse: // 권한 있음
                    newState.locationPermission = .gotPermission
                case .restricted, .notDetermined:
                    newState.locationPermission = .requestPermission // 아직 선택하지 않음
                case .denied:
                    newState.locationPermission = .presentSetting // 권한없음
                default:
                    newState.locationPermission = .none
                }
                return newState
            }
            .bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.viewState?
            .filter{$0 == .viewDidLoad}
            .withLatestFrom(state){ [weak self] viewState, state -> WriteState in
                var newState = state
                newState.viewLogic = .setUpView
                newState.categoryData = ["식비", "생활비", "유흥비"]
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.coorState?
            .withLatestFrom(state){ coor, state -> WriteState in
                var newState = state
                newState.coordi = coor
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.mode?
            .withLatestFrom(state)
            .map{ [weak self] state -> WriteState in
                var newState = state
                if newState.locaSetMode == .auto{
                    newState.locaSetMode = .directly
                }else{
                    newState.locaSetMode = .auto
                }
                print("mode: \(newState.locaSetMode)")
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        output = Output(state: state.asDriver())
        return output!
    }
}

struct WriteState{
    var presentVC: PresentVC?
    var viewLogic: ViewLogic?
    var categoryData: [String]?
    var locationPermission: PermissionState?
    var coordi: CLLocationCoordinate2D?
    var locaSetMode: LocationSetMode? = .auto
}

extension WriteViewModel{
    
    
}

enum LocationSetMode{
    case auto
    case directly
}
