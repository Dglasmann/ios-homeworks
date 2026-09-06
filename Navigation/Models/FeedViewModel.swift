//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Sasha Soldatov on 11.05.2026.
//

import Foundation
import StorageService

final class FeedViewModel: ViewModelProtocol {
    
    
    enum ViewInput {
        case checkGuess(word: String?)
        case openPost(Post)
    }
    
    
    //MARK: - State
    enum State: Equatable {
        case initial
        case correct
        case incorrect
    }
    
    
    //MARK: - Bindings
    var onStateDidChange: ((State) -> Void)?
    
    //MARK: - Private
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    private let feedService: FeedServiceProtocol
    
    private weak var coordinator: FeedCoordinator?
    
    //MARK: - Init
    init(feedService: FeedServiceProtocol, coordinator: FeedCoordinator? = nil) {
        self.feedService = feedService
        self.coordinator = coordinator
    }
    
    //MARK: - Input
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .checkGuess(let word):
            guard let word, !word.isEmpty else { return }
            state = feedService.check(word: word) ? .correct : .incorrect
            
        case .openPost(let post):
            coordinator?.showPost(post)
        }
    }
}
    
