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

struct FirebaseReadRepository{
    
    private var fbCallback: FirebaseReadProtocol!
    private let disposeBag = DisposeBag()
    
    init(fbCallBack: FirebaseReadProtocol){
        self.fbCallback = fbCallBack
    }
}

extension FirebaseReadRepository{
    func readBookInfo(){
        let db = Firestore.firestore()
        let ref = db.collection("account_array").document("accountData")
            .getDocument{ (document, error) in
                if let data = document?.data() {
                    let profileJson = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    Observable<Data>.just(profileJson)
                        .decode(type: SnapInfo.self, decoder: JSONDecoder())
                        .subscribe(onNext: { snapInfo in
                            fbCallback.bookInfoList(bookList: snapInfo.book_list)
                        }, onError: { error in
                            print("error in read FB \(error)")
                        }).disposed(by: self.disposeBag)
                }
            }
    }
    
}
