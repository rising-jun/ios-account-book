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
        let firebaseDatabase = Firestore.firestore()
        let _ = firebaseDatabase.collection("account_array").document("accountData")
            .getDocument{ (document, error) in
                guard let data = document?.data() else { return completion(.failure(.nilDataError))}
                guard let profileJson = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {
                    return completion(.failure(.jsonParsingError))
                }
                Observable<Data>.just(profileJson)
                    .decode(type: SnapInfo.self, decoder: JSONDecoder())
                    .subscribe(onNext: { snapInfo in
                        completion(.success(snapInfo.book_list))
                    }, onError: { error in
                        completion(.failure(.snapError))
                    }).disposed(by: self.disposeBag)
            }
    }
    
}
enum FireBaseError: Error{
    case snapError
    case writeError
    case nilDataError
    case jsonParsingError
}
