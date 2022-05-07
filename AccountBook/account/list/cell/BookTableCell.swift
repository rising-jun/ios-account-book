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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI(){
        contentView.addSubViews(dateLabel, titleLabel, categoryLabel, priceLabel)

        contentView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(self)
        }
        
        dateLabel.textColor = .black
        dateLabel.font = UIFont.boldSystemFont(ofSize: 30)
        dateLabel.textAlignment = .center
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.height.width.equalTo(70)
            make.top.equalTo(self).offset(5)
        }
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(150)
            make.leading.equalTo(dateLabel.snp.trailing).offset(30)
        }
        
        priceLabel.textColor = .red
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-0)
            make.centerY.equalTo(contentView.snp.centerY)
            make.height.equalTo(50)
            make.width.equalTo(80)
        }
        
        categoryLabel.textColor = .black
        categoryLabel.font = UIFont.systemFont(ofSize: 18)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.centerX.equalTo(titleLabel.snp.centerX)
        }
    }
}
