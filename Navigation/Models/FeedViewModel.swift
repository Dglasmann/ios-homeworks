//
//  FeedViewModel.swift
//  Navigation
//
//  вьюмодель «Главной» — лента постов всех авторов из PostService.
//  умеет сохранять пост в «Сохранённое» и открывать детали поста
//

import Foundation
import StorageService

final class FeedViewModel: ViewModelProtocol {

    // MARK: - State

    enum State: Equatable {
        case loaded
    }

    // MARK: - ViewInput

    enum ViewInput {
        case viewDidLoad
        case toggleSave(index: Int)
        case openPost(index: Int)
    }

    // MARK: - Bindings

    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .loaded {
        didSet { onStateDidChange?(state) }
    }

    // MARK: - Data

    private(set) var posts: [PostModel] = []

    // MARK: - Dependencies

    private let postService: PostServiceProtocol
    private let favouritesService: FavouritesServiceProtocol
    private weak var coordinator: FeedCoordinator?

    // MARK: - Init

    init(
        postService: PostServiceProtocol,
        favouritesService: FavouritesServiceProtocol,
        coordinator: FeedCoordinator?
    ) {
        self.postService = postService
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
            state = .loaded

        case .toggleSave(let index):
            toggleSave(at: index)

        case .openPost(let index):
            guard let post = post(at: index) else { return }
            coordinator?.showPost(Post(title: post.author))
        }
    }

    // MARK: - Private

    /// закладка работает как переключатель: если пост уже в «Сохранённом» —
    /// убираем, иначе добавляем
    private func toggleSave(at index: Int) {
        guard let post = post(at: index) else { return }
        if favouritesService.isFavourite(post) {
            favouritesService.delete(post) { [weak self] in self?.state = .loaded }
        } else {
            favouritesService.save(post) { [weak self] in self?.state = .loaded }
        }
    }
}
