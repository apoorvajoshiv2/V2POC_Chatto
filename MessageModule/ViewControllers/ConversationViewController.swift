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
    var chatInputPresenter: BaseMessageChatInputBarPresenter!
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
        self.view.backgroundColor = UIColor(red: 232.0/255, green: 233.0/255, blue: 237.00/255, alpha: 1.0)
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
        let chatInputView = MessageChatInputBar.loadNib()
        var appearance = MessageChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("New Message", comment: "")
        self.chatInputPresenter = BaseMessageChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }
    
//    override func createChatInputView() -> UIView {
//        let chatInputView = ChatInputBar.loadNib()
//        var appearance = ChatInputBarAppearance()
//        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
//        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
//        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
//        chatInputView.maxCharactersCount = 1000
//        return chatInputView
//    }
    
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        items.append(self.createPhotoInputItem())
        return items
        
    }
    
    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            self?.dataSource.addPhotoMessage(image: image)
        }
        return item
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
        let failedIconImage = BaseMessageCollectionViewCellDefaultStyle.FailedIconImages(normal: UIImage(named: "uploadFailedIcon")!, highlighted: UIImage(named: "uploadFailedIcon")!)
        // colors, bubbleBorderImages, failedIconImages, layoutConstants,dateTextStyle, avatarStyle provided in BaseMessageCollectionViewCellDefaultStyle
        // used for base message background + text background
        let baseMessageStyle =  BaseMessageCollectionViewCellDefaultStyle(colors: chatColor, failedIconImages: failedIconImage)
        
        let textStyle = TextMessageCollectionViewCellDefaultStyle.TextStyle(
            font: UIFont.systemFont(ofSize: 13),
            incomingColor: UIColor.white, // white text for incoming
            outgoingColor: UIColor.white, // white text for outgoing
            incomingInsets: UIEdgeInsets(top: 10, left: 19.3, bottom: 11, right: 19.3),
            outgoingInsets: UIEdgeInsets(top: 10, left: 19.3, bottom: 11, right: 19.3)
        )
        
        var textCellStyle = TextMessageCollectionViewCellDefaultStyle()
        textCellStyle = TextMessageCollectionViewCellDefaultStyle(
            textStyle: textStyle,
            baseStyle: baseMessageStyle) // without baseStyle, we won't have the right background
        textMessagePresenter.baseMessageStyle = baseMessageStyle
        textMessagePresenter.textCellStyle = textCellStyle
        
        // Photo Presenter
        
        let photoMessagePresenter = PhotoMessagePresenterBuilder(
            viewModelBuilder: FNSPhotoMessageViewModelBuilder(),
            interactionHandler: FNSPhotoMessageHandler(baseHandler: self.baseMessageHandler)
        )
        
        return [
            FNSTextMessageModel.chatItemType:[
                textMessagePresenter
            ],
                GroupActivityModel.chatItemType:[
                    GroupActivityPresenterBuilder()
            ],
                SenderTimestampModel.chatItemType: [
                    SenderTimestampPresenterBuilder()
            ],
//                FNSPhotoMessageModel.chatItemType: [
//                    photoMessagePresenter
//            ],
                MediaMessageModel.chatItemType: [
                    MediaTextMessagePresenterBuilder()
            ]
        ]
    }
    
}
