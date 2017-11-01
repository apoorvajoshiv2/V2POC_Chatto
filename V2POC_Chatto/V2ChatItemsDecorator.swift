//
//  V2ChatItemsDecorator.swift
//  V2POC_Chatto
//
//  Created by apoorva on 30/10/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class V2ChatItemsDecorator: ChatItemsDecoratorProtocol {
    
    // Required method of ChatItemsDecoratorProtocol
    func decorateItems(_ chatItems: [ChatItemProtocol]) -> [DecoratedChatItem] {
        
        var decoratedChatItems = [DecoratedChatItem]()
        
        for (index, chatItem) in chatItems.enumerated() {
            
            // type is variable in ChatItemProtocol
            let next: ChatItemProtocol? = (index + 1 < chatItems.count) ? chatItems[index + 1] : nil
            let previous: ChatItemProtocol? = (index > 0) ? chatItems[index - 1] : nil
            var showsTail = false
            var additionalItems =  [DecoratedChatItem]()
            
            if let currentMessage = chatItem as?
                MessageModelProtocol {
                
                // senderId, isIncoming, date, status in MessageModelProtocol
                if let nextMessage = next as? MessageModelProtocol {
                    // if sender of current message and next message are same then no tail should be shown
                    showsTail = currentMessage.senderId != nextMessage.senderId
                } else {
                    showsTail = true
                }
                
                if currentMessage.type == "groupActivity" {
                    additionalItems.append(
                        DecoratedChatItem(
                            chatItem: GroupActivityModel(uid: "\(currentMessage.uid)-groupActivity", activityType: currentMessage.uid),
                            decorationAttributes: ChatItemDecorationAttributes(bottomMargin: 6.3, showsTail: false, canShowAvatar: false))
                    )
                }
                
            }
            
            // bottomMargin, canShowTail, canShowAvatar, canShowFailedIcon are provided by ChatItemDecorationAttributes
            
            decoratedChatItems.append(DecoratedChatItem(chatItem: chatItem, decorationAttributes: ChatItemDecorationAttributes(bottomMargin: 5.0, showsTail: true, canShowAvatar: showsTail)))
            
            decoratedChatItems.append(contentsOf: additionalItems)
        }
        
        return decoratedChatItems
    }
}
