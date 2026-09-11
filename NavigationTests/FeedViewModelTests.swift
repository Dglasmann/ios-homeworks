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
    
    private var sut: FeedService!
    
    override func setUp() {
        super.setUp()
        sut = FeedService(secretWord: "secretik")
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testCheckGuess_correctWord_setsCorrectState() {
        XCTAssertTrue(sut.check(word: "secretik"))
    }
    
    func test_check_withCorrectWord_returnsTrue() {
        XCTAssertTrue(sut.check(word: "secretik"))
    }

    func test_check_withIncorrectWord_returnsFalse() {
        XCTAssertFalse(sut.check(word: "wrong"))
    }

    func test_check_isCaseSensitive() {
        XCTAssertFalse(sut.check(word: "Secretik"))
    }

    func test_check_withEmptyString_returnsFalse() {
        XCTAssertFalse(sut.check(word: ""))
    }
}
