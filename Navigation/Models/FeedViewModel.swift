//
//  FeedViewModel.swift
//  Navigation
//
//  Вью-модель «Главной» — лента постов из сети (Rick and Morty API).
//  Умеет сохранять пост в «Сохранённое» и открывать детали поста.
//

import Foundation

final class FeedViewModel: ViewModelProtocol {

    // MARK: - State

    enum State: Equatable {
        case loading
        case loaded
        case error(String)
    }

    // MARK: - ViewInput

    enum ViewInput {
        case viewDidLoad
        case refresh
        case toggleSave(index: Int)
        case openPost(index: Int)
    }

    // MARK: - Bindings

    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .loading {
        didSet { onStateDidChange?(state) }
    }

    // MARK: - Data

    private(set) var posts: [PostModel] = []

    // MARK: - Dependencies

    private let feedService: FeedContentServiceProtocol
    private let favouritesService: FavouritesServiceProtocol
    private weak var coordinator: FeedCoordinator?

    // MARK: - Init

    init(
        feedService: FeedContentServiceProtocol,
        favouritesService: FavouritesServiceProtocol,
        coordinator: FeedCoordinator?
    ) {
        self.feedService = feedService
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
        case .viewDidLoad, .refresh:
            loadPosts()

        case .toggleSave(let index):
            toggleSave(at: index)

        case .openPost(let index):
            guard let post = post(at: index) else { return }
            coordinator?.showPost(post)
        }
    }

    // MARK: - Private
    
    private func loadPosts() {
        state = .loading
        feedService.fetchPosts { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let posts):
                self.posts = posts
                self.state = .loaded
            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }

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
