//
//  GoogleLoginToken.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import GoogleSignIn
import Firebase
import RxSwift

class GoogleLoginToken{
    
    var tokenPublish = PublishSubject<String>()
    
    func getGoogleToken(){
        print("get googlToken ")
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let vc = UIApplication.shared.keyWindow?.rootViewController as? LoginViewController
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: vc!) { [weak self] user, error in
            
            if let error = error {
                // ...
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            //print("googleToken : \(authentication.accessToken)")
            //move data to viewmodel, publishSubject reference error resolving...
            self?.tokenPublish.onNext(authentication.accessToken)
        }
        
    }
    
}
