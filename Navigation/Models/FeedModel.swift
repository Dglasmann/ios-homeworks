//
//  FeedModel.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.05.2026.
//

import Foundation

extension Notification.Name {
    static let feedCheckResult = Notification.Name("feedCheckResult")
}


class FeedModel {
    private let secretWord: String = "secretik"
    
    func check(word: String) {
        let isCorrect = (word == secretWord)
        NotificationCenter.default.post(name: .feedCheckResult, object: nil, userInfo: ["isCorrect": isCorrect])
    }
}
