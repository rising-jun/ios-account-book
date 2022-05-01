//
//  ViewModelProtocol.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation

protocol ViewModelType{
    associatedtype Input
    associatedtype Output
    
    var input: Input? { get }
    var output: Output? { get }
}
