//
//  WriteViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/08.
//

import RxSwift
import RxCocoa
import CoreLocation

final class WriteViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<WriteState>(value: WriteState())
    private let writeResult = PublishSubject<FirebaseWriteResult>()
    private let firebaseWriteable: FirebaseWriteable?
    private let writeExpressionCheckable: WriteExpressionCheckable
    init(firebaseWriteable: FirebaseWriteable, writeExpressionCheckable: WriteExpressionCheckable){
        self.firebaseWriteable = firebaseWriteable
        self.writeExpressionCheckable = writeExpressionCheckable
    }
    
    struct Input{
        let viewState: Observable<ViewState>?
        let locState: Observable<CLAuthorizationStatus>?
        let coorState: Observable<CLLocationCoordinate2D>?
        let mode: Observable<Void>?
        let nameInput: Observable<String>?
        let priceInput: Observable<String>?
        let categoryInput: Observable<Int>?
        let writeAction: Observable<Void>?
        let dateInput: Observable<Date>?
        let backAction: Observable<Void>?
        //뒤로가기 추가해야함
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
            .withLatestFrom(state){ viewState, state -> WriteState in
                var newState = state
                newState.viewLogic = .setUpView
                newState.categoryData = ["식비", "생활비", "유흥비"]
                guard let categoryData = newState.categoryData else { return state }
                newState.writeObject.setCategory(value: categoryData[0])
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)

        input.coorState?
            .withLatestFrom(state){ coor, state -> WriteState in
                var newState = state
                newState.coordi = coor
                newState.writeObject.setPoint(lat: coor.latitude, long: coor.longitude)
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)

        input.mode?
            .withLatestFrom(state)
            .map{ state -> WriteState in
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
                let newState = state
                newState.writeObject.setName(value: name)
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)

        input.priceInput?
            .withLatestFrom(state){ [weak self] price, state -> WriteState in
                guard let self = self else { return state }
                var newState = state
                if self.writeExpressionCheckable.checkPrice(price: price){
                    newState.writeObject.setPrice(value: price)
                    newState.priceformError = .possible
                }else{
                    newState.priceformError = .impossible
                }
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)

        input.categoryInput?
            .withLatestFrom(state){ row, state -> WriteState in
                let newState = state
                guard let categoryData = newState.categoryData else { return state }
                newState.writeObject.setCategory(value: categoryData[row])
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)

        input.dateInput?
            .withLatestFrom(state){ date, state -> WriteState in
                let newState = state
                newState.writeObject.setDate(value: date.formatted())
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)

        input.writeAction?
            .withLatestFrom(state)
            .map{ [weak self] state in
                guard let self = self else { return state }
                print("write button tapped")
                let newState = state
                if newState.priceformError == .impossible{
                    print("priceform error")
                }else{
                    newState.writeObject.setUserId(value: UserDefaults.standard.string(forKey: "token") ?? "null")
                    self.firebaseWriteable?.writeBookInfo(bookInfo: newState.writeObject) { result in
                        switch result {
                        case .success(let value):
                            self.writeResult(result: value)
                        case .failure(let error):
                            print("Firebase Write \(error)")
                        }
                    }
                }
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)

        input.backAction?
            .withLatestFrom(state)
            .map{ state -> WriteState in
                var newState = state
                newState.presentViewController = .list
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)

        writeResult.withLatestFrom(state){ result, state -> WriteState in
            var newState = state
            switch result{
            case .success:
                newState.presentViewController = .list
                newState.resultMsg = .success
            case .failed(_):
                newState.resultMsg = .failed
            }
            return newState
        }.bind(to: self.state)
            .disposed(by: disposeBag)
        return Output(state: state.asDriver())
    }
}

extension WriteViewModel{
    private func writeResult(result: FirebaseWriteResult) {
        print("writeResult!! : \(result)")
        writeResult.onNext(result)
    }
}


struct WriteState{
    var presentViewController: ViewControllerType?
    var viewLogic: ViewLogic?
    var categoryData: [String]?
    var locationPermission: PermissionState?
    var coordi: CLLocationCoordinate2D?
    var locaSetMode: LocationSetMode? = .auto
    var priceformError: PossibleCheck? = .impossible
    var writeObject = BookInfo()
    var dateInfo: String = ""
    var resultMsg: WriteResultMsg?
}


enum LocationSetMode{
    case auto
    case directly
}

enum PossibleCheck{
    case possible
    case impossible
}

enum WriteResultMsg{
    case success
    case failed
}
