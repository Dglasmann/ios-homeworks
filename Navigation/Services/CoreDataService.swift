//
//  CoreDataService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 24.06.2026.
//


import Foundation
import CoreData

final class CoreDataService {
    static let shared = CoreDataService()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavouritesModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData load error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    //MARK: - Create
    
    func savePost(_ post: PostModel) {
        
        if isFavourite(post) { return }
        
        let favourite = FavouritePost(context: context)
        favourite.author = post.author
        favourite.descriptionText = post.description
        favourite.image = post.image
        favourite.views = Int64(post.views)
        favourite.likes = Int64(post.likes)
        saveContext()
    }
    
    //MARK: - Read
    func fetchPosts() -> [PostModel] {
        let request: NSFetchRequest<FavouritePost> = FavouritePost.fetchRequest()
        do {
            let result = try context.fetch(request)
            return result.map { PostModel(author: $0.author, description: $0.descriptionText, image: $0.image, likes: Int($0.likes), views: Int($0.views))
            }
        } catch {
            print("Fatal error: \(error.localizedDescription)")
            return []
        }
    }
    
    
    //MARK: - Delete
    
    func deletePost(_ post: PostModel) {
        let request: NSFetchRequest<FavouritePost> = FavouritePost.fetchRequest()
        request.predicate = NSPredicate(
            format: "author == %@ AND descriptionText == %@",
            post.author, post.description
        )
        
        do {
            let objects = try context.fetch(request)
            objects.forEach {
                context.delete($0)
                saveContext()
            }
        } catch {
            print("Delete error: \(error.localizedDescription)")
        }
    }
    
    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }
    func isFavourite(_ post: PostModel) -> Bool {
        let request: NSFetchRequest<FavouritePost> = FavouritePost.fetchRequest()
        request.predicate = NSPredicate(
            format: "author == %@ AND descriptionText == %@",
            post.author, post.description
        )
        
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
        
    }
}
