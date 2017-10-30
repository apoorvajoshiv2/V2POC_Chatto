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
    
    var messageSender: MessageSender!
    var chatInputPresenter: BasicChatInputBarPresenter!
    var dataSource: MessageDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
        }
    }
    
    
    
    
    lazy private var baseMessageHandler: FNSBaseMessageHandler = {
        //        return V2BaseMessageInteractionHandler(messageSender: self.messageSender)
        
        return FNSBaseMessageHandler(messageSender: self.messageSender)
    }()
    
    override func loadView() {
        super.loadView()
        // dataSource and messageSender need to be initialised here
        //        let pageSize = 50
        //        dataSource = FakeDataSource(messages: [], pageSize: pageSize)
        
        
        
        // setup database
        
        let messageFactory = MockMessageFactory.sharedInstance
        messageFactory.initialize()
        messageFactory.insertMessagesInDataBase()
        let allMessageData =  messageFactory.getAllMessages()
        print(allMessageData)
        
        
        configureFetchedResultsController()
        
        do {
            try fetchedResultsController.performFetch()
            
            self.dataSource = MessageDataSource(withController: fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
            self.messageSender = dataSource.messageSender
        } catch {
            print("An error occurred")
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "V2 Conversations"
        
        super.chatItemsDecorator = V2ChatItemsDecorator()
        
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
            self?.dataSource.addTextMessage(text: text)
        }
        return item
    }
    
    // A collection of Presenter Builders are given to the ConversationViewController to configure the cells
    
    override func createPresenterBuilders() -> [ChatItemType : [ChatItemPresenterBuilderProtocol]] {
        
        let textMessagePresenter = TextMessagePresenterBuilder(viewModelBuilder: TextMessagesViewModelBuilder(),
                                                               interactionHandler: FNSTextMessageHandler(baseHandler: self.baseMessageHandler))
        
        // To set color of incoming and outgoing message bubbles
        let chatColor = BaseMessageCollectionViewCellDefaultStyle.Colors(
            incoming: UIColor(red: 117.0/255, green: 154.0/255, blue: 124.00/255, alpha: 1.0), // green background for incoming
            outgoing: UIColor(red: 48.0/255, green: 107.0/255, blue: 136.00/255, alpha: 1.0) // blue background for outgoing
        )
        
        // colors, bubbleBorderImages, failedIconImages, layoutConstants,dateTextStyle, avatarStyle provided in BaseMessageCollectionViewCellDefaultStyle
        // used for base message background + text background
        let baseMessageStyle =  BaseMessageCollectionViewCellDefaultStyle(colors: chatColor)
        
        //        let borderImage = createDefaultBubbleeBorderImages()
        //        let baseMessageStyle =  BaseMessageCollectionViewCellDefaultStyle(colors: chatColor, bubbleBorderImages: borderImage)
        
        let textStyle = TextMessageCollectionViewCellDefaultStyle.TextStyle(
            font: UIFont.systemFont(ofSize: 13),
            incomingColor: UIColor.white, // white text for incoming
            outgoingColor: UIColor.white, // white text for outgoing
            incomingInsets: UIEdgeInsets(top: 10, left: 19.3, bottom: 11, right: 19.3),
            outgoingInsets: UIEdgeInsets(top: 10, left: 19.3, bottom: 11, right: 19.3)
        )
        
        var textCellStyle = TextMessageCollectionViewCellDefaultStyle()
        //        let cellImage = createDefaultBubbleeImages
        textCellStyle = TextMessageCollectionViewCellDefaultStyle(
            textStyle: textStyle,
            baseStyle: baseMessageStyle) // without baseStyle, we won't have the right background
        textMessagePresenter.baseMessageStyle = baseMessageStyle
        textMessagePresenter.textCellStyle = textCellStyle
        
        return [FNSTextMessageModel.chatItemType: [textMessagePresenter]]
    }
    
    
    // To set image to Bubble border
    func createDefaultBubbleeBorderImages() -> BaseMessageCollectionViewCellDefaultStyle.BubbleBorderImages {
        return BaseMessageCollectionViewCellDefaultStyle.BubbleBorderImages(
            borderIncomingTail: UIImage(named: "bubble")!,
            borderIncomingNoTail: UIImage(named: "bubble")!,
            borderOutgoingTail: UIImage(named: "bubble")!,
            borderOutgoingNoTail: UIImage(named: "bubble")!
        )
    }
    
    // To set image to bubble
    func createDefaultBubbleeImages() -> TextMessageCollectionViewCellDefaultStyle.BubbleImages {
        return TextMessageCollectionViewCellDefaultStyle.BubbleImages(
            incomingTail: UIImage(named: "bubble")!,
            incomingNoTail: UIImage(named: "bubble")!,
            outgoingTail: UIImage(named: "bubble")!,
            outgoingNoTail: UIImage(named: "bubble")!
        )
    }
    
}
