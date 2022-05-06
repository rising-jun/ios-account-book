//
//  GoogleLoginToken.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import GoogleSignIn
import RxSwift
import Firebase

protocol GoogleLoginable{
    func getGoogleToken(completion: @escaping (Result<String, SnsLoginError>) -> Void)
}

struct GoogleLoginToken: GoogleLoginable{
    func getGoogleToken(completion: @escaping (Result<String, SnsLoginError>) -> Void){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController as? LoginViewController else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in
            guard let authentication = user?.authentication, let idToken = authentication.idToken else {
                return completion(.failure(.authenticationError))
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                guard let authResult = authResult else { return completion(.failure(.authResultError)) }
                completion(.success(authResult.user.uid))
            }
        }
    }
}

enum SnsLoginError: Error{
    case signinError
    case authenticationError
    case authResultError
    case error
}
