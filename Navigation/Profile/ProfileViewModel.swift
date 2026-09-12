//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Sasha Soldatov on 10.09.2026.
//

import UIKit

final class ProfileViewModel: ViewModelProtocol {

    // MARK: - State

    enum State: Equatable {
        case loaded
    }

    // MARK: - ViewInput

    enum ViewInput {
        case viewDidLoad
        case didTapPhotosSection
        case toggleSave(index: Int)
        case didDropPost(image: UIImage, description: String, at: Int)
        case didTapEdit
        case logout
    }

    // MARK: - Bindings

    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .loaded {
        didSet { onStateDidChange?(state) }
    }

    // MARK: - Data

    let user: User
    private(set) var posts: [PostModel] = []
    private(set) var previewPhotos: [UIImage] = []

    // MARK: - Dependencies

    private let postService: PostServiceProtocol
    private let photoService: PhotoServiceProtocol
    private let favouritesService: FavouritesServiceProtocol
    private weak var coordinator: ProfileCoordinator?

    // MARK: - Init

    init(
        user: User,
        postService: PostServiceProtocol,
        photoService: PhotoServiceProtocol,
        favouritesService: FavouritesServiceProtocol,
        coordinator: ProfileCoordinator? = nil
    ) {
        self.user = user
        self.postService = postService
        self.photoService = photoService
        self.favouritesService = favouritesService
        self.coordinator = coordinator
    }

    // MARK: - Helpers

    func post(at index: Int) -> PostModel? {
        posts.indices.contains(index) ? posts[index] : nil
    }

    func isSaved(at index: Int) -> Bool {
        guard let post = post(at: index) else { return false }
        return favouritesService.isFavourite(post)
    }

    // MARK: - ViewModelProtocol

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .viewDidLoad:
            posts = postService.posts()
            previewPhotos = Array(photoService.photos().prefix(4))
            state = .loaded

        case .didTapPhotosSection:
            coordinator?.showPhotos()

        case .toggleSave(let index):
            toggleSave(at: index)

        case .didDropPost(let image, let description, let index):
            let newPost = PostModel(
                author: L10n.Profile.dragDropAuthor,
                description: description,
                image: image,
                likes: 0,
                views: 0
            )
            postService.addPost(newPost, at: index)
            posts = postService.posts()
            state = .loaded

        case .didTapEdit:
            coordinator?.showEditProfile(user: user) { [weak self] name, profession, status in
                self?.applyEdits(name: name, profession: profession, status: status)
            }

        case .logout:
            coordinator?.logout()
        }
    }

    // MARK: - Private

    private func toggleSave(at index: Int) {
        guard let post = post(at: index) else { return }
        if favouritesService.isFavourite(post) {
            favouritesService.delete(post) { [weak self] in self?.state = .loaded }
        } else {
            favouritesService.save(post) { [weak self] in self?.state = .loaded }
        }
    }

    private func applyEdits(name: String, profession: String, status: String) {
        user.fullName = name
        user.profession = profession
        user.status = status
        state = .loaded
    }
}
