//
//  FirebaseWriteRepositoryStub.swift
//  AccountBookTests
//
//  Created by 김동준 on 2022/05/15.
//

import Foundation
@testable import AccountBook

struct FirebaseWriteRepositoryStub: FirebaseWriteable{
    private let isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func writeBookInfo(bookInfo: BookInfo, completion: @escaping (Result<FirebaseWriteResult, FireBaseError>) -> Void) {
        isSuccess ? completion(.success(.success)) : completion(.failure(.nilDataError))
    }
}
