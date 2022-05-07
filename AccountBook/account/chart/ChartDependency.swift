//
//  ChartDependency.swift
//  AccountBook
//
//  Created by 김동준 on 2022/05/07.
//

import Foundation

struct ChartDependency: Dependency{
    typealias ViewModelType = ChartViewModel
    let viewModel: ChartViewModel
}
