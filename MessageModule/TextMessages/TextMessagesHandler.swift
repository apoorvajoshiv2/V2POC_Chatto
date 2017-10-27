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
    
    private let baseHandler: V2BaseMessageInteractionHandler
    init (baseHandler: V2BaseMessageInteractionHandler) {
        self.baseHandler = baseHandler
    }

    // All these methods are required
    func userDidTapOnBubble(viewModel: FNSTextMessageViewModel) {
        self.baseHandler.userDidTapOnBubble(viewModel: viewModel) 
    }
    
    func userDidTapOnAvatar(viewModel: FNSTextMessageViewModel) {
        self.baseHandler.userDidTapOnAvatar(viewModel: viewModel)
    }
    
    func userDidEndLongPressOnBubble(viewModel: FNSTextMessageViewModel) {
        self.baseHandler.userDidEndLongPressOnBubble(viewModel: viewModel)
    }
    
    func userDidBeginLongPressOnBubble(viewModel: FNSTextMessageViewModel) {
        self.baseHandler.userDidBeginLongPressOnBubble(viewModel: viewModel)
    }
 
    func userDidTapOnFailIcon(viewModel: FNSTextMessageViewModel, failIconView: UIView) {
        self.baseHandler.userDidTapOnFailIcon(viewModel: viewModel)
    }
    
   
   
    
}
