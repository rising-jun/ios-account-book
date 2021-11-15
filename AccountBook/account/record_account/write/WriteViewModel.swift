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
import FirebaseDatabase

final class WriteViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<WriteState>(value: WriteState())
    
    struct Input{
        let viewState: Observable<ViewState>?
        let locState: Observable<CLAuthorizationStatus>?
        let coorState: Observable<CLLocationCoordinate2D>?
        let mode: Observable<Void>?
        let nameInput: Observable<String>?
        let priceInput: Observable<String>?
        let categoryInput: Observable<Int>?
        let writeAction: Observable<Void>?
        
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
                newState.writeObject.lat = coor.latitude
                newState.writeObject.long = coor.longitude
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
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.nameInput?
            .withLatestFrom(state){ name, state -> WriteState in
                var newState = state
                print("name in viewmodel \(name)")
                newState.writeObject.name = name
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.priceInput?
            .withLatestFrom(state){ [weak self] price, state -> WriteState in
                var newState = state
                
                if self!.checkPrice(price: price){
                    newState.writeObject.price = price
                    newState.priceformError = .possible
                }else{
                    newState.priceformError = .impossible
                }
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.categoryInput?
            .withLatestFrom(state){ [weak self] row, state -> WriteState in
                var newState = state
                print("category in viewmodel \(newState.categoryData![row])")
                newState.writeObject.category = newState.categoryData![row]
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.writeAction?
            .withLatestFrom(state)
            .map{ state in
                var newState = state
                if newState.priceformError == .impossible{
                    
                }else{
                    if let userId = UserDefaults.standard.string(forKey: "token"){
                        var ref: DatabaseReference!
                        ref = Database.database().reference()
                        
                        
                    }
                    
                    
                }
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
    var priceformError: PossibleCheck?
    var writeObject = BookInfo()
}

extension WriteViewModel{
    
    private func checkPrice(price: String) -> Bool{
        // 정규식!
        let regEx: String = "^[0-9]*$"
        let regExTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        return regExTest.evaluate(with: price)
    }
    
    
}

enum LocationSetMode{
    case auto
    case directly
}

enum PossibleCheck{
    case possible
    case impossible
}
