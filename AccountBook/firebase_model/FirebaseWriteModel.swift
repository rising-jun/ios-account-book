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

protocol FirebaseWriteProtocol{
    func writeResult(result: Bool)
}

class FirebaseWriteModel{
    
    private let disposeBag = DisposeBag()
    
    private var result: FirebaseWriteProtocol!
    
    init(result: FirebaseWriteProtocol){
        self.result = result
    }
    
    
}

extension FirebaseWriteModel{
    
    func writeBookInfo(bookInfo: BookInfo){
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(bookInfo)
        let json = String(data: jsonData, encoding: .utf8)
        
        if let data = json!.data(using: .utf8) {
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let db = Firestore.firestore()
                db.collection("account_array")
                    .document("accountData")
                    .updateData(["book_list" : FieldValue.arrayUnion([result])]){
                        [weak self] err in
                    }
                self.result.writeResult(result: true)
            } catch {
                print(error.localizedDescription)
                print("catch")
                self.result.writeResult(result: false)
            }
        }
        
        
    }
    
}
