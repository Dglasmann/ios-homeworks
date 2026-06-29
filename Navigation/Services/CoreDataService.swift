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
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        return backgroundContext
    }()
    
    //MARK: - Create
    
    func savePost(_ post: PostModel, completeion: (() -> Void)? = nil) {
        
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            if self.isFavourite(post, in: self.backgroundContext) {
                DispatchQueue.main.async { completeion?() }
                return
            }
            
        }
        
        
        let favourite = FavouritePost(context: self.backgroundContext)
        favourite.author = post.author
        favourite.descriptionText = post.description
        favourite.image = post.image
        favourite.views = Int64(post.views)
        favourite.likes = Int64(post.likes)
        
        self.save(self.backgroundContext)
        DispatchQueue.main.async {
            completeion?()
        }
    }
    
    //MARK: - Read
    func fetchPosts(author: String) -> [PostModel] {
        let request: NSFetchRequest<FavouritePost> = FavouritePost.fetchRequest()
        request.predicate = NSPredicate(format: "author == %@", author)
        do {
            let result = try viewContext.fetch(request)
            return result.map { PostModel(
                author: $0.author,
                description: $0.descriptionText,
                image: $0.image,
                likes: Int($0.likes),
                views: Int($0.views)
            )
            }
        } catch {
            print("Fatal error: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchPosts() -> [PostModel] {
        let request: NSFetchRequest<FavouritePost> = FavouritePost.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            return result.map {
                PostModel(
                    author: $0.author,
                    description: $0.descriptionText,
                    image: $0.image,
                    likes: Int($0.likes),
                    views: Int($0.views)
                )
            }
        } catch {
            print("Fetch error: \(error.localizedDescription)")
            return []
        }
    }
    
    //MARK: - Delete
    
    func deletePost(_ post: PostModel, completeion: (() -> Void)? = nil) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            let request: NSFetchRequest<FavouritePost> = FavouritePost.fetchRequest()
            request.predicate = NSPredicate(
                format: "author == %@ AND descriptionText == %@",
                post.author, post.description
            )
            do {
                let objects = try self.backgroundContext.fetch(request)
                objects.forEach {
                    self.backgroundContext.delete($0)
                }
                self.save(self.backgroundContext)
            } catch {
                print("Delete error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completeion?()
            }
        }
       
    }
    
    func isFavourite(_ post: PostModel) -> Bool {
            isFavourite(post, in: viewContext)
        }
    
    private func isFavourite(_ post: PostModel, in context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<FavouritePost> = FavouritePost.fetchRequest()
        request.predicate = NSPredicate(
            format: "author == %@ AND descriptionText == %@",
            post.author, post.description
        )
        
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
        
    }
    
    private func save(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }
    
}
