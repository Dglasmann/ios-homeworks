//
//  PostServiceTests.swift
//  Navigation
//
//  Created by Sasha Soldatov on 11.09.2026.
//

import XCTest
@testable import Navigation

final class PostServiceTests: XCTestCase {
    
    private var sut: PostService!
    private func makePost(_ author: String) -> PostModel {
        PostModel(
            author: author,
            description: "test",
            image: UIImage(),
            likes: 0,
            views: 0
        )
    }
    
    override func setUp() {
        super.setUp()
        sut = PostService(storage: [makePost("a"), makePost("b")])
    }
    
    func test_posts_returnsInitialStorage() {
        XCTAssertEqual(sut.posts().count, 2)
    }
    
    func test_addPost_insertAtGivenIndex() {
        sut.addPost(makePost("new"), at: 1)
        XCTAssertEqual(sut.posts()[1].author, "new")
    }
    
    func test_addPost_withIndexBeyondBounds_appendsToEnd() {
        sut.addPost(makePost("new"), at: 999)
        XCTAssertEqual(sut.posts().last?.author, "new")
    }
    
    func test_addPost_withNegativeIndex_insertsAtStart() {
        sut.addPost(makePost("new"), at: -5)
        XCTAssertEqual(sut.posts().first?.author, "new")
    }
}
