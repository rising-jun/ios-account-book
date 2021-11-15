//
//  LoginViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<LoginState>(value: LoginState())
    private let disposeBag = DisposeBag()
    private var tokenPublish = PublishSubject<String>()
    let googleLoginModel = GoogleLoginToken()
    
    struct Input{
        let viewState: Observable<ViewState>?
        let googleLoginTap: Observable<Void>?
        
    }
    
    struct Output{
        var state: Driver<LoginState>?
    }
    
    func bind(input: Input) -> Output{
        self.input = input
            
        input.viewState?
            .filter{$0 == .viewDidLoad}
            .withLatestFrom(state){ viewState, state -> LoginState in
                var newState = state
                newState.viewLogic = .setUpView
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.googleLoginTap?
            .withLatestFrom(state)
            .map{ [weak self] state -> LoginState in
                var newState = state
                self?.getGoogleToken()
                self!.tokenPublish.map{
                    
                    if (UserDefaults.standard.string(forKey: "token") != ""){

                    }else{
                        let userToken = $0.replacingOccurrences(of: ".", with: "_")
                        UserDefaults.standard.setValue(userToken, forKey: "token")
                    }
                    newState.presentVC = .list
                    return newState
                }.bind(to: self!.state)
                .disposed(by: self!.disposeBag)
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        output = Output(state: state.asDriver())
        return output!
    }
    
    
}

struct LoginState{
    var presentVC: PresentVC?
    var viewLogic: ViewLogic?
    var userToken: String?
    
}

extension LoginViewModel{
    
    func getGoogleToken(){
        self.googleLoginModel.tokenPublish = self.tokenPublish
        googleLoginModel.getGoogleToken()
    }
    
}
