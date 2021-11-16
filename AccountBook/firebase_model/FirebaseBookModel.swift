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

protocol FirebaseModelProtocol{
    func bookInfoList(bookList: [BookInfo])
    
}

class FirebaseBookModel{
    
    private var fbCallback: FirebaseModelProtocol!
    private let disposeBag = DisposeBag()
    
    init(fbCallBack: FirebaseModelProtocol){
        self.fbCallback = fbCallBack
    }
    
    init(){
        
    }
    
    
}

extension FirebaseBookModel{
    
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
    
    func writeBookInfo(){
        if let userToken = UserDefaults.standard.string(forKey: "token"){
            print("what is userId \(userToken)")
            
            var obj = [
                "userId": userToken,
                "name": "La Angeles",
                "price": "20000",
                "category": "USA",
                "lat": 1,
                "long": 2,
                "date": "2021-11-15 10:20"] as [String : Any]
            
            let db = Firestore.firestore()
            
            db.collection("account_array")
                .document("accountData")
                .updateData(["book_list" : FieldValue.arrayUnion([obj])]){
                    error in
                    print(error)
                }
        }
    }
    
}
