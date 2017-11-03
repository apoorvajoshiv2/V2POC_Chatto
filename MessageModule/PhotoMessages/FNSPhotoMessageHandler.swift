//
//  FNSPhotoMessageHandler.swift
//  V2POC_Chatto
//
//  Created by apoorva on 03/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import ChattoAdditions

class FNSPhotoMessageHandler: BaseMessageInteractionHandlerProtocol {
    private let baseHandler: FNSBaseMessageHandler
    init (baseHandler: FNSBaseMessageHandler) {
        self.baseHandler = baseHandler
    }
    
    func userDidTapOnFailIcon(viewModel: FNSPhotoMessageViewModel, failIconView: UIView) {
        self.baseHandler.userDidTapOnFailIcon(viewModel: viewModel)
    }
    
    func userDidTapOnAvatar(viewModel: FNSPhotoMessageViewModel) {
        self.baseHandler.userDidTapOnAvatar(viewModel: viewModel)
    }
    
    func userDidTapOnBubble(viewModel: FNSPhotoMessageViewModel) {
        self.baseHandler.userDidTapOnBubble(viewModel: viewModel)
    }
    
    func userDidBeginLongPressOnBubble(viewModel: FNSPhotoMessageViewModel) {
        self.baseHandler.userDidBeginLongPressOnBubble(viewModel: viewModel)
    }
    
    func userDidEndLongPressOnBubble(viewModel: FNSPhotoMessageViewModel) {
        self.baseHandler.userDidEndLongPressOnBubble(viewModel: viewModel)
    }
}

