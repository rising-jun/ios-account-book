//
//  BookInfo.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import RxDataSources

public struct SnapInfo: Codable{
    let book_list: [BookInfo]
}

public final class BookInfo: Codable{
    private(set) var userId: String = ""
    private(set) var name: String = ""
    private(set) var lat: Double = 0.0
    private(set) var long: Double = 0.0
    private(set) var price: String = ""
    private(set) var category: String = ""
    private(set) var date: String = ""{
        didSet{
            date = splitDateString(from: date)
        }
    }
    
    func setPoint(lat: Double, long: Double){
        self.lat = lat
        self.long = long
    }
    
    func setCategory(value: String){
        self.category = value
    }
    
    func setName(value: String){
        self.name = value
    }
    
    func setPrice(value: String){
        self.price = value
    }
    
    func setDate(value: String){
        self.date = value
    }
    
    func setUserId(value: String){
        self.userId = value
    }
    
    private func splitDateString(from date: String) -> String{
        let startIdx: String.Index = date.index(date.startIndex, offsetBy: 9)
        let endIdx: String.Index = date.index(date.startIndex, offsetBy: 10)
        return String(date[startIdx ..< endIdx])
    }
}

struct MySection{
    let header: String
    var items: [Item]
}

extension MySection: SectionModelType{
    typealias Item = BookInfo
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
    
}

class ChartInfo{
    private(set) var category: String = ""
    private(set) var percent: Double = 0.0
    private(set) var value: Double = 0.0
    
    init(category: String, percent: Double, value: Double){
        self.category = category
        self.percent = percent
        self.value = value
    }
    
    func setValue(value: Double){
        self.value = value
    }
}
