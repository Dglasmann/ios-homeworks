//
//  FeedViewModelTests.swift
//  Navigation
//
//  Created by Sasha Soldatov on 12.08.2026.
//

import XCTest
@testable import Navigation

@MainActor
final class FeedViewModelTests: XCTestCase {
    
    var viewModel: FeedViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = FeedViewModel(feedService: FeedService(), coordinator: nil)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testCheckGuess_correctWord_setsCorrectState() {
        //when
        viewModel.updateState(viewInput: .checkGuess(word: "secretik"))
        
        //then
        XCTAssertEqual(viewModel.state, .correct)
    }
    
    func testCheckGuess_incorrectWord_setsIncorrectState() {
        //when
        viewModel.updateState(viewInput: .checkGuess(word: "wrong"))
        
        //then
        XCTAssertEqual(viewModel.state, .incorrect)
    }
    
    func testCheckGuess_emptyWord_stateStaysInitial() {
        //when
        viewModel.updateState(viewInput: .checkGuess(word: ""))
        
        //then
        XCTAssertEqual(viewModel.state, .initial)
    }
}

