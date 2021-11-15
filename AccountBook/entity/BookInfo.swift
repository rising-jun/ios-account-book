//
//  BookInfo.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxDataSources

public struct SnapInfo: Codable{
    var account: [BookInfo]
}

public struct BookInfo: Codable{
    var userId: String = ""
    var name: String = ""
    var lat: Double = 0.0
    var long: Double = 0.0
    var price: String = ""
    var category: String = ""
    var date: String = ""
}

struct MySection{
    var header: String
    var items: [Item]

}

extension MySection: SectionModelType{
    typealias Item = BookInfo
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
    
}
