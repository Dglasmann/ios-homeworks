//
//  FavouritesViewModel.swift
//  Navigation
//
//  Created by Sasha Soldatov on 10.09.2026.
//

import CoreData

final class FavouritesViewModel: NSObject, ViewModelProtocol {
    enum State: Equatable {
        case loaded
        case empty
    }
    
    enum ViewInput {
        case viewDidLoad
        case applyFilter(author: String?)
        case clearFilter
        case delete(at: IndexPath)
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    var onWillChangeContent: (() -> Void)?
    var onDidChangeContent: (() -> Void)?
    var onChange: ((NSFetchedResultsChangeType, IndexPath?, IndexPath?) -> Void)?

    
    private(set) var state: State = .loaded {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    private let favouritesService: FavouritesServiceProtocol
    private var fetchedResultsController: NSFetchedResultsController<FavouritePost>?
    
    init(
        favouritesService: FavouritesServiceProtocol,
    ) {
        self.favouritesService = favouritesService
        super.init()

    }
    
    var numberOfRows: Int {
        fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func post(at indexPath: IndexPath) -> PostModel? {
        guard let object = fetchedResultsController?.object(at: indexPath) else { return nil }
        return PostModel(from: object)
    }
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .viewDidLoad:
            reload(author: nil)
        case .applyFilter(let author):
            reload(author: author)
        case .clearFilter:
            reload(author: nil)
        case .delete(let indexPath):
            guard let post = post(at: indexPath) else { return }
            favouritesService.delete(post) {
                [weak self] in
                self?.updateEmptyState()
            }
        }
    }
    
    private func reload(author: String?) {
        let controller = favouritesService.makeFetchedResultsController(author: author)
        controller.delegate = self
        fetchedResultsController = controller

        do {
            try controller.performFetch()
            updateEmptyState()
        } catch {
            assertionFailure("FRC fetch failed: \(error.localizedDescription)")
            state = .empty
        }
    }

    private func updateEmptyState() {
        state = numberOfRows == 0 ? .empty : .loaded
    }
}

extension FavouritesViewModel: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        onWillChangeContent?()
    }

    func controller(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        onChange?(type, indexPath, newIndexPath)
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        onDidChangeContent?()
        updateEmptyState()
    }
}
