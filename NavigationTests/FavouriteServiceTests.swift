//
//  FavouriteServiceTests.swift
//  Navigation
//
//  Created by Sasha Soldatov on 11.09.2026.
//

import XCTest
import CoreData
@testable import Navigation

final class FavouriteServiceTests: XCTestCase {
    
    private var coreDataService: CoreDataService!
    private var sut: FavouritesService!
    
    private let post = PostModel(
        author: "test.author",
        description: "test description",
        image: UIImage(systemName: "star") ?? UIImage(),
        likes: 10,
        views: 29
    )
    
    override  func setUp() {
        super.setUp()
        coreDataService = CoreDataService(inMemory: true)
        sut = FavouritesService(coreDataService: coreDataService)
    }
    
    override func tearDown() {
        sut = nil
        coreDataService = nil
        super.tearDown()
    }
    
    func test_save_addsPostToFavourites() {
        let expectation = expectation(description: "post saved")
        sut.save(post) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(sut.isFavourite(post))
    }
    
    func test_save_sameTwice_doesNotDuplicate() {
        let first = expectation(description: "first")
        sut.save(post) {
            first.fulfill()
        }
        wait(for: [first], timeout: 2)
        
        let second = expectation(description: "second")
        sut.save(post) {
            first.fulfill()
        }
        wait(for: [second], timeout: 2)
        
        XCTAssertEqual(coreDataService.fetchPosts().count, 1)
    }
    
    func test_delete_removesPost() {
        let saved = expectation(description: "saved")
        sut.save(post) { saved.fulfill() }
        wait(for: [saved], timeout: 2)
        
        let deleted = expectation(description: "deleted")
        sut.delete(post) { deleted.fulfill() }
        wait(for: [deleted], timeout: 2)
        
        XCTAssertFalse(sut.isFavourite(post))
    }

    func test_fetchPosts_filterIsCaseInsensitive() {
        let saved = expectation(description: "saved")
        sut.save(post) { saved.fulfill() }
        wait(for: [saved], timeout: 2)
        
        XCTAssertEqual(coreDataService.fetchPosts(author: "TEST").count, 1)
        XCTAssertEqual(coreDataService.fetchPosts(author: "nonexistent").count, 0)
    }
}
