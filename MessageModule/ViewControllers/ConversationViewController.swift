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
    
    //var dataSource: MessageDataSource! // Need to replace the below FakeDataSource with this

    var messageSender: FakeMessageSender!
    var chatInputPresenter: BasicChatInputBarPresenter!
    var dataSource: FakeDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
        }
    }



    
    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender)
    }()
    
    override func loadView() {
        super.loadView()
        // dataSource and messageSender need to be initialised here
        let pageSize = 50
        dataSource = FakeDataSource(messages: [], pageSize: pageSize)
        self.messageSender = dataSource.messageSender
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "V2 Conversations"

        super.chatItemsDecorator = ChatItemsDemoDecorator()
        
        // setup database 
        
        let messageFactory = MockMessageFactory.sharedInstance
        messageFactory.initialize()
        messageFactory.insertMessagesInDataBase()
        let allMessageData =  messageFactory.getAllMessages()
        print(allMessageData)
        
        configureFetchedResultsController()
        
        do {
            try fetchedResultsController.performFetch()
            
//            self.dataSource = MessageDataSource(withController: fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
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
    
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }
    
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        return items

    }
    
    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }
    
    // A collection of Presenter Builders are given to the ConversationViewController to configure the cells
    
    override func createPresenterBuilders() -> [ChatItemType : [ChatItemPresenterBuilderProtocol]] {
        let textMessagePresenter = TextMessagePresenterBuilder(viewModelBuilder: TextMessagesViewModelBuilder(), interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler))
        
        return [DemoTextMessageModel.chatItemType: [textMessagePresenter]]
        
    }

}
