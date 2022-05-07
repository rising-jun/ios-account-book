//
//  BookTableDelegate.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import UIKit

final class BookTableDelegate: NSObject{
    private let accountBooks: [BookInfo]
    
    init(accountArr: [BookInfo]){
        self.accountBooks = accountArr
    }
}

extension BookTableDelegate: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookInfo = accountBooks[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableCell.identifier, for: indexPath) as? BookTableCell else {
            return UITableViewCell()
        }
        cell.setCellInfo(from: bookInfo)
        return cell
    }
}
