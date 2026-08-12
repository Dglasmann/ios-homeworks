//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Sasha Soldatov on 11.05.2026.
//

import Foundation

class FeedViewModel {
    
    //MARK: - State
    nonisolated enum State: Equatable {
        case initial
        case correct
        case incorrect
    }
    
    //MARK: - Bindings
    var onStateDidChange: ((State) -> Void)?
    
    //MARK: - Private
    
    private let feedModel: FeedModel
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    //MARK: - Init
    init(feedModel: FeedModel = FeedModel()) {
        self.feedModel = feedModel
        subscribeToModel()
    }
    
    //MARK: - Input
    func checkGuess(word: String?) {
        guard let word = word, !word.isEmpty else { return }
        feedModel.check(word: word)
    }
    
    private func subscribeToModel() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCheckResult(_:)),
            name: .feedCheckResult,
            object: nil
        )
    }
    
    
    @objc private func handleCheckResult(_ notification: Notification) {
        guard let isCorrect = notification.userInfo?["isCorrect"] as? Bool else { return }
        state = isCorrect ? .correct : .incorrect
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
 }
