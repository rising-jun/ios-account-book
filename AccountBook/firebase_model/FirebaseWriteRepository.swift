//
//  FirebaseWriteModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/17.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

protocol BookWriteRepository{
    func writeBookInfo(bookInfo: BookInfo, completion: @escaping(Result<FirebaseWriteResult, FireBaseError>) -> Void)
}

struct FirebaseWriteRepository{
    private let disposeBag = DisposeBag()
}

extension FirebaseWriteRepository: BookWriteRepository{
    func writeBookInfo(bookInfo: BookInfo, completion: @escaping(Result<FirebaseWriteResult, FireBaseError>) -> Void){
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(bookInfo)
        let json = String(data: jsonData, encoding: .utf8)
        
        if let data = json!.data(using: .utf8) {
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let db = Firestore.firestore()
                db.collection("account_array")
                    .document("accountData")
                    .updateData(["book_list" : FieldValue.arrayUnion([result])])
                completion(.success(.success))
            } catch {
                completion(.failure(.writeError))
            }
        }
    }
}

enum FirebaseWriteResult{
    case success
    case failed(error: FireBaseError)
}
