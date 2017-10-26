
//
//  ChatViewController.swift
//  V2POC_Chatto
//
//  Created by apoorva on 18/10/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions

class ChatViewController: BaseChatViewController {
    
    var chatInputPresenter: BasicChatInputBarPresenter!
    
    var dataSource: FakeDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
        }
    }
    var messageSender: FakeMessageSender!
    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender)
    }()
    
    override func loadView() {
        super.loadView()
        let pageSize = 50
        self.dataSource = FakeDataSource(messages: TutorialMessageFactory.createMessages(), pageSize: pageSize)
        
        self.messageSender = self.dataSource.messageSender
        super.chatItemsDecorator = ChatItemsDemoDecorator()
        
        
        
        let messageFactory = MockMessageFactory.sharedInstance
        messageFactory.initialize()
        messageFactory.insertMessagesInDataBase()
        let allMessageData =  messageFactory.getAllMessages()
        print(allMessageData)
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chatto Default Demo"
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
        items.append(self.createPhotoInputItem())
        return items
    }
    
    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }
    
    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
//            self?.dataSource.addPhotoMessage(image)
        }
        return item
    }
    
    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler)
        )
        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()
        
        return [
            DemoTextMessageModel.chatItemType: [
                textMessagePresenter
            ],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()]
        ]
    }
    
    @objc
    private func addRandomIncomingMessage() {
        self.dataSource.addRandomIncomingMessage()
    }
    
}
