//
//  MapDependency.swift
//  AccountBook
//
//  Created by 김동준 on 2022/05/07.
//

import Foundation

struct MapDependency: Dependency{
    typealias ViewModelType = MapViewModel
    let viewModel: MapViewModel
}
