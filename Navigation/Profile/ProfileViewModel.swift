//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Sasha Soldatov on 10.09.2026.
//

import UIKit

final class ProfileViewModel: ViewModelProtocol {
    
    
    //MARK: - State
    enum State: Equatable {
        case loaded
        case postSaved
        case sessionTimeUpdated(String)
    }
    
    //MARK: - Viewinput
    
    enum ViewInput {
        case viewDidLoad
        case didTapPhotosSection
        case didDoubleTapPost(at: Int)
        case didDropPost(image: UIImage, description: String, at: Int)
        case screenDidAppear
        case screenDidDisappear
    }
    
    //MARK: - Bindings
    
    var onStateDidChange: ((State) -> Void)?
    
    private(set) var state: State = .loaded {
        didSet {
            onStateDidChange?(state)
        }
    }
   
    
    //MARK: - Data
    
    let user: User
    private(set) var posts: [PostModel] = []
    private(set) var previewPhotos: [UIImage] = []
    
    //MARK: - Dependencies
    private let postService: PostServiceProtocol
    private let photoService: PhotoServiceProtocol
    private let favouritesService: FavouritesServiceProtocol
    private weak var coordinator: ProfileCoordinator?
    
    
    private var sessionTimer: Timer?
    private var sessionSeconds: Int = 0
    
    //MARK: - Init
    
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
    
    deinit {
        stopSessionTimer()
    }
    
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .viewDidLoad:
            posts = postService.posts()
            previewPhotos = Array(photoService.photos().prefix(4))
            state = .loaded
            
        case .didTapPhotosSection:
            coordinator?.showPhotos()
            
        case .didDoubleTapPost(let index):
            guard posts.indices.contains(index) else { return }
            favouritesService.save(posts[index]) { [weak self] in
                self?.state = .postSaved
            }
            
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
            
        case .screenDidAppear:
            startSessionTimer()
            
        case .screenDidDisappear:
            stopSessionTimer()
        }
    }
    
    private func startSessionTimer() {
        sessionSeconds = 0
        publishSessionTime()
        
        let timer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true) { [weak self] _ in
                guard let self else { return }
                self.sessionSeconds += 1
                self.publishSessionTime()
            }
        RunLoop.current.add(timer, forMode: .common)
        sessionTimer = timer
    }
    
    private func stopSessionTimer() {
        sessionTimer?.invalidate()
        sessionTimer = nil
    }
    
    private func publishSessionTime() {
        let formatted = String(format: "%02d:%02d", sessionSeconds / 60, sessionSeconds % 60)
        state = .sessionTimeUpdated(L10n.Profile.sessionTime(formatted))
    }
}
