//
//  Message+CoreDataProperties.swift
//  V2POC_Chatto
//
//  Created by Nitesh Meshram on 10/24/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var commentCount: Int16
    @NSManaged public var createdOn: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var isEligibleForLatest: Bool
    @NSManaged public var isGroupActivity: Bool
    @NSManaged public var isMessageClear: Bool
    @NSManaged public var isNewPost: Bool
    @NSManaged public var isRead: Bool
    @NSManaged public var isSent: Bool
    @NSManaged public var isVimeoMedia: Bool
    @NSManaged public var localIdentifier: String?
    @NSManaged public var mediaType: String?
    @NSManaged public var mediaUrl: String?
    @NSManaged public var text: String?
    @NSManaged public var conversation: Conversation?
    @NSManaged public var medias: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for medias
extension Message {

    @objc(addMediasObject:)
    @NSManaged public func addToMedias(_ value: Media)

    @objc(removeMediasObject:)
    @NSManaged public func removeFromMedias(_ value: Media)

    @objc(addMedias:)
    @NSManaged public func addToMedias(_ values: NSSet)

    @objc(removeMedias:)
    @NSManaged public func removeFromMedias(_ values: NSSet)

}
