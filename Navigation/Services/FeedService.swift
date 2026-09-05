//
//  FeedService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.09.2026.
//  Проверка секретного слова.
//

final class FeedService: FFeedServiceProtocol {
    
    private let secretWord: String
    
    init(secretWord: String) {
        self.secretWord = secretWord
    }
    
    func check(word: String) -> Bool {
        word == secretWord
    }
    
}
