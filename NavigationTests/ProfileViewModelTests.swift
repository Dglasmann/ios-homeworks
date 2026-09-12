//
//  ProfileViewModelTests.swift
//  Navigation
//
//  Created by Sasha Soldatov on 11.09.2026.
//

import XCTest
@testable import Navigation

@MainActor
final class ProfileViewModelTests: XCTestCase {
    
    private var postService: PostServiceMock!
    private var favouritesService: FavouritesServiceMock!
    private var sut: ProfileViewModel!
    
    private let post = PostModel(
        author: "a",
        description: "a",
        image: UIImage(),
        likes: 1,
        views: 1
    )
    
    private let user = User(
        login: "admin",
        fullName: "Test",
        avatar: UIImage(),
        status: "Status"
    )
    
    override func setUp() {
        super.setUp()
        postService = PostServiceMock()
        postService.stubbedPosts = [post]
        favouritesService = FavouritesServiceMock()
        sut = ProfileViewModel(
            user: user,
            postService: postService,
            photoService: PhotoServiceMock(),
            favouritesService: favouritesService,
            coordinator: nil
        )
    }
    
    func test_viewDidLoad_loadsPosts() {
        sut.updateState(viewInput: .viewDidLoad)
        XCTAssertEqual(sut.posts.count, 1)
        XCTAssertEqual(sut.state, .loaded)
    }
    
    func test_toggleSave_savesToFavourites() {
        sut.updateState(viewInput: .viewDidLoad)
        sut.updateState(viewInput: .toggleSave(index: 0))

        XCTAssertEqual(favouritesService.savedPosts.first?.author, "a")
    }

    func test_toggleSave_withInvalidIndex_doesNothing() {
        sut.updateState(viewInput: .viewDidLoad)
        sut.updateState(viewInput: .toggleSave(index: 99))

        XCTAssertTrue(favouritesService.savedPosts.isEmpty)
    }
}
