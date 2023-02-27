//
//  FavoriteNews+CoreDataProperties.swift
//  
//
//  Created by Alexandr on 26.02.2023.
//
//

import Foundation
import CoreData


extension FavoriteNews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteNews> {
        return NSFetchRequest<FavoriteNews>(entityName: "FavoriteNews")
    }

    @NSManaged public var isPressed: Bool
    @NSManaged public var newsDate: String?
    @NSManaged public var newsHeadline: String?
    @NSManaged public var newsImage: String?
    @NSManaged public var newsIndexInArray: Int16
    @NSManaged public var newsText: String?

}
