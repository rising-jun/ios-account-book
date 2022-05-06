//
//  IntroDependency.swift
//  AccountBook
//
//  Created by 김동준 on 2022/05/01.
//

import Foundation

struct IntroDependency: Dependency{
    typealias ViewModelType = IntroViewModel
    let viewModel: IntroViewModel
}
