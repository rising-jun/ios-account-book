//
//  FirebaseBookModel.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/16.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

protocol FirebaseReadProtocol{
    func bookInfoList(bookList: [BookInfo])
    
}

class FirebaseReadModel{
    
    private var fbCallback: FirebaseReadProtocol!
    private let disposeBag = DisposeBag()
    
    init(fbCallBack: FirebaseReadProtocol){
        self.fbCallback = fbCallBack
    }
    
    init(){
        
    }
    
    
}

extension FirebaseReadModel{
    
    func readBookInfo(){
        let db = Firestore.firestore()
        let ref = db.collection("account_array").document("accountData")
            .getDocument{ (document, error) in
                let profileJson = try! JSONSerialization.data(withJSONObject: document?.data(), options: .prettyPrinted)
                Observable<Data>.just(profileJson)
                    .decode(type: SnapInfo.self, decoder: JSONDecoder())
                    .bind { [weak self] snapInfo in
                        guard let self = self else { return }
                        self.fbCallback.bookInfoList(bookList: snapInfo.book_list)
                    }.disposed(by: self.disposeBag)
            }
    }
    
}
