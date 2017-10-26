//
//  TextMessagesHandler.swift
//  V2POC_Chatto
//
//  Created by apoorva on 26/10/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import ChattoAdditions

class TextMessagesHandler: BaseMessageInteractionHandlerProtocol {
    
    private let baseHandler: BaseMessageHandler
    init (baseHandler: BaseMessageHandler) {
        self.baseHandler = baseHandler
    }
    
    // All these methods are required
    func userDidTapOnBubble(viewModel: DemoTextMessageViewModel) {
        self.baseHandler.userDidTapOnBubble(viewModel: viewModel) 
    }
    
    func userDidTapOnAvatar(viewModel: DemoTextMessageViewModel) {
        self.baseHandler.userDidTapOnAvatar(viewModel: viewModel)
    }
    
    func userDidEndLongPressOnBubble(viewModel: DemoTextMessageViewModel) {
        self.baseHandler.userDidEndLongPressOnBubble(viewModel: viewModel)
    }
    
    func userDidBeginLongPressOnBubble(viewModel: DemoTextMessageViewModel) {
        self.baseHandler.userDidBeginLongPressOnBubble(viewModel: viewModel)
    }
    
    func userDidTapOnFailIcon(viewModel: DemoTextMessageViewModel, failIconView: UIView) {
        self.baseHandler.userDidTapOnFailIcon(viewModel: viewModel)
    }
    
}
