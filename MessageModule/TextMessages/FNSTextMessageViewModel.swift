//
//  FNSTextMessageViewModel.swift
//  V2POC_Chatto
//
//  Created by apoorva on 27/10/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import ChattoAdditions

class FNSTextMessageViewModel: TextMessageViewModel<FNSTextMessageModel>, FNSMessageViewModelProtocol  {

    
    public var messageModel: V2MessageModelProtocol {
        return self.textMessage
    }
    
    public override init(textMessage: FNSTextMessageModel, messageViewModel: MessageViewModelProtocol) {
        super.init(textMessage: textMessage, messageViewModel: messageViewModel)
    }
    
}

