//
//  Media+CoreDataProperties.swift
//  V2POC_Chatto
//
//  Created by Nitesh Meshram on 10/24/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import CoreData


extension Media {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
    }

    @NSManaged public var id: String?
    @NSManaged public var mediaThumbnail: String?
    @NSManaged public var mimeType: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String?

}
