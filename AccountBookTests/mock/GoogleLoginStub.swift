//
//  GoogleLoginStub.swift
//  AccountBookTests
//
//  Created by 김동준 on 2022/05/15.
//

import Foundation
@testable import AccountBook

struct GoogleLoginStub: GoogleLoginable{
    private let isSuccess: Bool
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func getGoogleToken(completion: @escaping (Result<String, SnsLoginError>) -> Void) {
        isSuccess ? completion(.success("TestToken")) : completion(.failure(.signinError))
    }
}
