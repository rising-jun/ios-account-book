//
//  FirebaseReadRepositoryStub.swift
//  AccountBookTests
//
//  Created by 김동준 on 2022/05/15.
//

import Foundation
@testable import AccountBook

struct FirebaseReadRepositoryStub: FirebaseReadable{
    private let isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func readBookInfo(completion: @escaping (Result<[BookInfo], FireBaseError>) -> Void) {
        isSuccess ? completion(.success([])) : completion(.failure(.nilDataError))
    }
}
