//
//  FNSTextMessageModel.swift
//  V2POC_Chatto
//
//  Created by apoorva on 27/10/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import ChattoAdditions

class FNSTextMessageModel: TextMessageModel<MessageModel>, DemoMessageModelProtocol {
    public override init(messageModel: MessageModel, text: String) {
        super.init(messageModel: messageModel, text: text)
    }
    
    // variable status is present in DemoMessageModelProtocol
    public var status: MessageStatus {
        get {
            return self._messageModel.status
        } set {
            self._messageModel.status = status
        }
    }
    
}
