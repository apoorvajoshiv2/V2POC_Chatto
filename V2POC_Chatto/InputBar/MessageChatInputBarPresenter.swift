//
//  MessageChatInputBarPresenter.swift
//  V2POC_Chatto
//
//  Created by apoorva on 27/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions

protocol MessageChatInputBarPresenter: class {
    var chatInputBar: MessageChatInputBar { get }
    func onDidBeginEditing()
    func onDidEndEditing()
    func onSendButtonPressed()
}


public class BaseMessageChatInputBarPresenter: NSObject, MessageChatInputBarPresenter {
    public let chatInputBar: MessageChatInputBar
    let chatInputItems: [ChatInputItemProtocol]
    var focusedItem: ChatInputItemProtocol?
    let notificationCenter: NotificationCenter
    
    public init(chatInputBar: MessageChatInputBar,
                chatInputItems: [ChatInputItemProtocol],
                chatInputBarAppearance: MessageChatInputBarAppearance,
                notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.chatInputBar = chatInputBar
        self.chatInputItems = chatInputItems
        self.chatInputBar.setAppearance(chatInputBarAppearance)
        self.notificationCenter = notificationCenter
        super.init()
        
        self.chatInputBar.presenter = self
        //        self.chatInputBar.inputItems = self.chatInputItems
        self.notificationCenter.addObserver(self, selector: #selector(BaseMessageChatInputBarPresenter.keyboardDidChangeFrame), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(BaseMessageChatInputBarPresenter.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(BaseMessageChatInputBarPresenter.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    deinit {
        self.notificationCenter.removeObserver(self)
    }
    
    private var lastKnownKeyboardHeight: CGFloat?
    
    private var allowListenToChangeFrameEvents = true
    
    @objc
    private func keyboardDidChangeFrame(_ notification: Notification) {
        guard self.allowListenToChangeFrameEvents else { return }
        guard let value = (notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        self.lastKnownKeyboardHeight = value.cgRectValue.height
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        self.allowListenToChangeFrameEvents = false
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        self.allowListenToChangeFrameEvents = true
    }
}

// MARK: ChatInputBarPresenter
extension BaseMessageChatInputBarPresenter {
    public func onDidEndEditing() {
        self.focusedItem = nil
        self.chatInputBar.textView.inputView = nil
        self.chatInputBar.showsTextView = true
        self.chatInputBar.showsSendButton = true
    }
    
    public func onDidBeginEditing() {
        if self.focusedItem == nil {
            for inputItem in self.chatInputItems where inputItem.presentationMode == .keyboard {
                self.focusedItem = inputItem
                break
            }
        }
    }
    
    func onSendButtonPressed() {
        let messageText = self.chatInputBar.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if messageText.characters.count > 0 {
            if let focusedItem = self.focusedItem {
                focusedItem.handleInput(messageText as AnyObject)
            }
        }
        self.chatInputBar.inputText = ""
    }

}
