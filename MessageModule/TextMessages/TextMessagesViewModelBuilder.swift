//
//  TextMessagesViewModelBuilder.swift
//  V2POC_Chatto
//
//  Created by apoorva on 26/10/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import ChattoAdditions

// This class helps to create Presenter Builder for Text which will be added as ChatItem in ConversationViewController.

class TextMessagesViewModelBuilder: ViewModelBuilderProtocol{
    
    // Need to create TextMessageModel and TextMessageViewModel
    
    public init(){}
    
    // MessageViewModelDefaultBuilder() is present in ChattoAdditions Framework
    
    let messageViewModelBuilder = MessageViewModelDefaultBuilder()
    
    func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is DemoTextMessageModel
    }
    
    func createViewModel(_ textMessage: DemoTextMessageModel) -> DemoTextMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(textMessage)
        let textMessageViewModel = DemoTextMessageViewModel(textMessage: textMessage, messageViewModel: messageViewModel)
        textMessageViewModel.avatarImage.value = UIImage(named: "userAvatar")
        return textMessageViewModel
    }
    
}
