//
//  Conversation+CoreDataProperties.swift
//  V2POC_Chatto
//
//  Created by Nitesh Meshram on 10/24/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import CoreData


extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged public var conversationMembers: NSObject?
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var isConversationDeleted: Bool
    @NSManaged public var name: String?
    @NSManaged public var postedOn: NSDate?
    @NSManaged public var role: String?
    @NSManaged public var type: String?
    @NSManaged public var unread: Bool
    @NSManaged public var createdBy: User?
    @NSManaged public var messages: NSSet?
    @NSManaged public var recepient: NSSet?

}

// MARK: Generated accessors for messages
extension Conversation {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

// MARK: Generated accessors for recepient
extension Conversation {

    @objc(addRecepientObject:)
    @NSManaged public func addToRecepient(_ value: User)

    @objc(removeRecepientObject:)
    @NSManaged public func removeFromRecepient(_ value: User)

    @objc(addRecepient:)
    @NSManaged public func addToRecepient(_ values: NSSet)

    @objc(removeRecepient:)
    @NSManaged public func removeFromRecepient(_ values: NSSet)

}
