//
//  MyPageDependency.swift
//  AccountBook
//
//  Created by 김동준 on 2022/05/07.
//

import Foundation

struct MyPageDependency: Dependency{
    typealias ViewModelType = MyPageViewModel
    let viewModel: MyPageViewModel    
}
