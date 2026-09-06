//
//  FavouritesService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 06.09.2026.
//

import CoreData

final class FavouritesService: FavouritesServiceProtocol {
    
    private let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func save(_ post: PostModel, completion: (() -> Void)?) {
        coreDataService.savePost(post, completion: completion)
    }
    
    func delete(_ post: PostModel, completion: (() -> Void)?) {
        coreDataService.deletePost(post, completion: completion)
    }
    
    func isFavourite(_ post: PostModel) -> Bool {
        coreDataService.isFavourite(post)
    }
    
    func makeFetchedResultsController(author: String?) -> NSFetchedResultsController<FavouritePost> {
        coreDataService.makeFetchedResultsController(author: author)
    }
    
    
}
