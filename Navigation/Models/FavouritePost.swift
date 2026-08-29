//
//  FavouritePost.swift
//  Navigation
//
//  Created by Sasha Soldatov on 24.06.2026.
//

import Foundation
import CoreData

@objc(FavouritePost)
public class FavouritePost: NSManagedObject {
    
    @NSManaged public var author: String
    @NSManaged public var descriptionText: String
    @NSManaged public var image: Data?
    @NSManaged public var views: Int64
    @NSManaged public var likes: Int64
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouritePost> {
        return NSFetchRequest<FavouritePost>(entityName: "FavouritePost")
    }
}
