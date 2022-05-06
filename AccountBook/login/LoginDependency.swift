//
//  LoginDependency.swift
//  AccountBook
//
//  Created by 김동준 on 2022/05/06.
//

import Foundation

struct LoginDependency: Dependency{
    typealias ViewModelType = LoginViewModel
    let viewModel: ViewModelType
}
