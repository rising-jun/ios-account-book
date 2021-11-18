//
//  BookTableDelegate.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import UIKit

class BookTableDelegate: NSObject{
    var accountArr: [BookInfo]?
    
    init(accountArr: [BookInfo]){
        self.accountArr = accountArr
    }
    
}

extension BookTableDelegate: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = accountArr![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableCell", for: indexPath) as? BookTableCell
        
        cell?.dateLabel.text = splitDateString(str: data.date)
        cell?.priceLabel.text = data.price
        cell?.titleLabel.text = data.name
        cell?.categoryLabel.text = data.category
        return cell!
    }
    
}

extension BookTableDelegate{
    func splitDateString(str: String) -> String{
        let startIdx: String.Index = str.index(str.startIndex, offsetBy: 9)
        let endIdx: String.Index = str.index(str.startIndex, offsetBy: 10)
        var result = String(str[startIdx ..< endIdx])
        return result
    }
}
