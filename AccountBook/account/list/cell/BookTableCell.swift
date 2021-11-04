//
//  BookTableCell.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import SnapKit
import UIKit

class BookTableCell: UITableViewCell{
    
    lazy var dateLabel = UILabel()
    lazy var titleLabel = UILabel()
    lazy var categoryLabel = UILabel()
    lazy var priceLabel = UILabel()
    
    override func awakeFromNib(){
        super.awakeFromNib()
        contentView.addSubViews(dateLabel, titleLabel, categoryLabel, priceLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.height.width.equalTo(50)
            make.top.equalTo(self).offset(10)
        }
        
    }
    
}
