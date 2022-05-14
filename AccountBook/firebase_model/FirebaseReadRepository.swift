//
//  FirebaseBookModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/16.
//

import RxSwift
import RxCocoa
import FirebaseFirestore

protocol FirebaseReadable{
    func readBookInfo(completion: @escaping(Result<[BookInfo], FireBaseError>) -> Void)
}

struct FirebaseReadRepository{
    private let disposeBag = DisposeBag()
}

extension FirebaseReadRepository: FirebaseReadable{
    func readBookInfo(completion: @escaping(Result<[BookInfo], FireBaseError>) -> Void){
        let documentSnapshotCompletion: ((DocumentSnapshot?, Error?) -> ()) = { document, error in
            DispatchQueue.global().async {
                guard let booksJson = document?.data() else { return completion(.failure(.nilDataError))}
                guard let profileJson = try? JSONSerialization.data(withJSONObject: booksJson, options: .prettyPrinted) else {
                    return completion(.failure(.jsonParsingError))
                }
                
                guard let bookList = try? JSONDecoder().decode(SnapInfo.self, from: profileJson).book_list else {
                    return completion(.failure(.jsonParsingError))
                }
                completion(.success(bookList))
            }
        }
        
        DispatchQueue.global().async {
            let firebaseDatabase = Firestore.firestore()
            let _ = firebaseDatabase.collection("account_array").document("accountData")
                .getDocument(completion: documentSnapshotCompletion)
        }
    }
}

enum FireBaseError: Error{
    case snapError
    case writeError
    case nilDataError
    case jsonParsingError
}
