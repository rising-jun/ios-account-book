//
//  BookInfo.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxDataSources

public struct BookInfo{
    
    var name: String
    var lat: Double
    var long: Double
    var price: String
    var category: String
    var date: Date
    
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

//public struct Category{
//    var dining: String = "dining"
//    var coffee: String = "coffee"
//    var life: String = "life"
//    var culture: String = "culture"
//    var transport: String = "transport"
//    var etc: String = "etc"
//}
