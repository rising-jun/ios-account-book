//
//  ListDependency.swift
//  AccountBook
//
//  Created by 김동준 on 2022/05/07.
//

import Foundation

struct ListDependency: Dependency{
    typealias ViewModelType = ListViewModel
    let viewModel: ListViewModel
}
