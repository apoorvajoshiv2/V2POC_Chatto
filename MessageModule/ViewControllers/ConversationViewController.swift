//
//  ConversationViewController.swift
//  V2POC_Chatto
//
//  Created by Nitesh Meshram on 10/26/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions
import CoreData

class ConversationViewController: BaseChatViewController,NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<Message>!
    
    var dataSource: MessageDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
        }
    }
    var messageSender: FakeMessageSender!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "V2 Conversations"
        
        // setup database 
        
        let messageFactory = MockMessageFactory.sharedInstance
        messageFactory.initialize()
        messageFactory.insertMessagesInDataBase()
        let allMessageData =  messageFactory.getAllMessages()
        print(allMessageData)
        
//        let pageSize = 50
//        
//        
//        var fetchedResultsController: NSFetchedResultsController<Message>!
//        self.dataSource = MessageDataSource(withController: fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        
        
        
        //FakeDataSource(messages: TutorialMessageFactory.createMessages(), pageSize: pageSize)
        
//        self.messageSender = self.dataSource.messageSender
//        super.chatItemsDecorator = ChatItemsDemoDecorator()
        
        
        configureFetchedResultsController()
        
        do {
            try fetchedResultsController.performFetch()
            
            self.dataSource = MessageDataSource(withController: fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        } catch {
            print("An error occurred")
            
        }


        
    }
    
    func configureFetchedResultsController() {
        let messageFactory = MockMessageFactory.sharedInstance
        let messageFetchRequest = NSFetchRequest<Message>(entityName: "Message")
        let primarySortDescriptor = NSSortDescriptor(key: "id", ascending: true)
//        let secondarySortDescriptor = NSSortDescriptor(key: "id", ascending: true)
//        animalsFetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
        messageFetchRequest.sortDescriptors = [primarySortDescriptor]
        self.fetchedResultsController = NSFetchedResultsController<Message>(
            fetchRequest: messageFetchRequest,
            managedObjectContext: messageFactory.managedObjectContext ,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        self.fetchedResultsController.delegate = self
        
    }
}
