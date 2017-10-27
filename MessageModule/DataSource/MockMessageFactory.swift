//
//  MockMessageFactory.swift
//  V2POC_Chatto
//
//  Created by Nitesh Meshram on 10/25/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import CoreData

import Chatto
import ChattoAdditions




class MockMessageFactory {
    
    static let sharedInstance: MockMessageFactory = {
        let instance = MockMessageFactory()
        // setup code
        return instance
    }()
    
    func initialize() {
    }
    
    
    
    static let mockMessages = [
        ("text", "Core Data Message 1"),
        ("text", "Core Data Message 2"),
        ("text", "Core Data Message 3"),
        ("text", "Core Data Message 4 => urls: https://github.com/badoo/Chatto, phone numbers: 07400000000, dates: 3 jan 2016 and others"),
        ("image", "pic-test-1")
    ]
    
    var mockDBMessages = [Message]()
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.v2solutions.V2SwiftApplication" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("applicationDocumentsDirectory Path =>  \(urls)")
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "FNS-Health", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("FNS-Health.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    func insertMessagesInDataBase() { //  -> [Message]
        
        for (index, message) in MockMessageFactory.mockMessages.enumerated() {
            
            if !self.getMessagesbyId(messageId: "mockData-\(index)") {
                let entityDescription = NSEntityDescription.entity(forEntityName: "Message", in: self.managedObjectContext)
                let newMessage = NSManagedObject(entity: entityDescription!, insertInto: self.managedObjectContext)
                
                let mediaType = message.0 // Text / Image / Video
                let content = message.1
                
                newMessage.setValue("mockData-\(index)", forKey: "id")
                newMessage.setValue(content, forKey: "text")
                newMessage.setValue(mediaType, forKey: "mediaType")
                
                do {
                    try newMessage.managedObjectContext?.save()
                    
                } catch {
                    print(error)
                }
            }
            
            
            
        }
        
    }
    
    func getAllMessages() -> [Message] {
        // Initialize Fetch Request
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Message", in: self.managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        var result = [Message]()
        do {
            result = try self.managedObjectContext.fetch(fetchRequest) as! [Message]
            print(result)
            return result
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return result
        }
        return result
    }
    
    func getMessagesbyId(messageId: String) -> Bool {
        // Initialize Fetch Request
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Message", in: self.managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "id == %@", messageId)
        //        var result = [Message]()
        do {
            let result = try self.managedObjectContext.fetch(fetchRequest) //as! [Message]
            
            if (result.count > 0) {
                return true
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return false
        }
        return false
        
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Message> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        
        // Configure Fetch Request
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
//        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    
}

