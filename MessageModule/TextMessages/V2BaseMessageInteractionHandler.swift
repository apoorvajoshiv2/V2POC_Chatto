//
//  BaseMessageInteractionHandler.swift
//  V2POC_Chatto
//
//  Created by apoorva on 27/10/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

public protocol FNSMessageViewModelProtocol {
    // Need to create DemoMessageModelProtocol for FNS
    var messageModel: V2MessageModelProtocol {get}
}

class V2BaseMessageInteractionHandler {
    // Need to create MessageSender for FNS
    private let messageSender: MessageSender
    init (messageSender: MessageSender) {
        self.messageSender = messageSender
    }
//  
    /*
    func userDidTapOnFailIcon(viewModel: FNSMessageViewModelProtocol) {
        print("userDidTapOnFailIcon")
        self.messageSender.sendMessage(viewModel.messageModel)
    }

    func userDidTapOnAvatar(viewModel: MessageViewModelProtocol) {
        print("userDidTapOnAvatar")
    }
    
    func userDidTapOnBubble(viewModel: FNSMessageViewModelProtocol) {
        print("userDidTapOnBubble")
    }
    
    func userDidBeginLongPressOnBubble(viewModel: FNSMessageViewModelProtocol) {
        print("userDidBeginLongPressOnBubble")
    }
    
    func userDidEndLongPressOnBubble(viewModel: FNSMessageViewModelProtocol) {
        print("userDidEndLongPressOnBubble")
    }
*/
    
}
