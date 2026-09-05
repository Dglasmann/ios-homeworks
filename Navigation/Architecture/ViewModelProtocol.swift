//
//  ViewModelProtocol.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.09.2026.
//


import Foundation

protocol ViewModelProtocol: AnyObject {
    
    associatedtype State
    associatedtype ViewInput
    
    var state: State { get }
    
    var onStateDidChange: ((State) -> Void?) { get set }
    
    func updateState(viewInput: ViewInput)
}
