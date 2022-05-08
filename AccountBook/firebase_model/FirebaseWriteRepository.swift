//
//  FirebaseWriteModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/17.
//

import RxSwift
import RxCocoa
import FirebaseFirestore

protocol FirebaseWriteable{
    func writeBookInfo(bookInfo: BookInfo, completion: @escaping(Result<FirebaseWriteResult, FireBaseError>) -> Void)
}

struct FirebaseWriteRepository{
    private let disposeBag = DisposeBag()
    
}
extension FirebaseWriteRepository: FirebaseWriteable{
    func writeBookInfo(bookInfo: BookInfo, completion: @escaping(Result<FirebaseWriteResult, FireBaseError>) -> Void){
        DispatchQueue.global().async {
            let jsonEncoder = JSONEncoder()
            guard let jsonData = try? jsonEncoder.encode(bookInfo) else {
                return completion(.failure(.jsonParsingError))
            }
            let json = String(data: jsonData, encoding: .utf8)
            guard let data = json?.data(using: .utf8) else {
                return completion(.failure(.jsonParsingError))
            }
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) else {
                return completion(.failure(.jsonParsingError))
            }
            
            guard let resultJson = result as? [String: Any] else { return completion(.failure(.jsonParsingError))}
            let firebaseDatabase = Firestore.firestore()
            firebaseDatabase.collection("account_array")
                .document("accountData")
                .updateData(["book_list" : FieldValue.arrayUnion([resultJson])])
            completion(.success(.success))
        }
    }
}

enum FirebaseWriteResult{
    case success
    case failed(error: FireBaseError)
}
