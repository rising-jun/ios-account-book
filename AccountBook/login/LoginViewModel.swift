//
//  LoginViewModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    init(googleLoginable: GoogleLoginable){
        self.googleLoginable = googleLoginable
    }
    
    private let state = BehaviorRelay<LoginState>(value: LoginState())
    private let disposeBag = DisposeBag()
    private var tokenPublish = PublishSubject<String>()
    private let googleLoginable: GoogleLoginable
    
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
        
        input.googleLoginTap?.bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.getGoogleToken()
        }).disposed(by: disposeBag)
        
        tokenPublish.withLatestFrom(state){ userUID, state -> LoginState in
            var newState = state
            newState.presentViewController = .list
            guard let _ = UserDefaults.standard.string(forKey: "token") else {
                UserDefaults.standard.setValue(userUID, forKey: "token")
                return newState
            }
            return newState
        }.bind(to: self.state)
        .disposed(by: disposeBag)

        return Output(state: state.asDriver())
    }
}

struct LoginState{
    var presentViewController: ViewControllerType?
    var viewLogic: ViewLogic?
    var userToken: String?
}

extension LoginViewModel{
    private func getGoogleToken(){
        googleLoginable.getGoogleToken { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let userUid):
                self.tokenPublish.onNext(userUid)
            case .failure(let error):
                print(error)
            }
        }
    }
}
