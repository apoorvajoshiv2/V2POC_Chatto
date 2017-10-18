
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
    var dataSource: ChatDataSourceProtocol!
//    var dataSource: ChatDataSource! {
//        didSet {
//            self.chatDataSource = self.dataSource
//        }
//    }
    
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
//            self?.dataSource.addTextMessage(text)
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
    
}
