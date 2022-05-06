//
//  WriteDependency.swift
//  AccountBook
//
//  Created by 김동준 on 2022/05/06.
//

import Foundation

struct WriteDependency: Dependency{
    typealias ViewModelType = WriteViewModel
    let viewModel: WriteViewModel
}
