//
//  User+CoreDataProperties.swift
//  V2POC_Chatto
//
//  Created by Nitesh Meshram on 10/24/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var contactNumber: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: String?
    @NSManaged public var lastName: String?
    @NSManaged public var role: String?
    @NSManaged public var conversationCreator: NSSet?
    @NSManaged public var posts: NSSet?
//    @NSManaged public var profile: Profile?
//    @NSManaged public var programs: Program?

}

// MARK: Generated accessors for conversationCreator
extension User {

    @objc(addConversationCreatorObject:)
    @NSManaged public func addToConversationCreator(_ value: Conversation)

    @objc(removeConversationCreatorObject:)
    @NSManaged public func removeFromConversationCreator(_ value: Conversation)

    @objc(addConversationCreator:)
    @NSManaged public func addToConversationCreator(_ values: NSSet)

    @objc(removeConversationCreator:)
    @NSManaged public func removeFromConversationCreator(_ values: NSSet)

}

// MARK: Generated accessors for posts
extension User {

//    @objc(addPostsObject:)
//    @NSManaged public func addToPosts(_ value: Post)

//    @objc(removePostsObject:)
//    @NSManaged public func removeFromPosts(_ value: Post)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}
