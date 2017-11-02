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
            if let currentMessage = chatItem as?
                MessageModelProtocol {
                
                // TimeStamp for every message
                // Needs modification when integrating in FNS to pass sender's name and proper time
                
                let dateTimeStamp = DecoratedChatItem(chatItem: SenderTimestampModel(uid: "\(currentMessage.uid)-time-separator", date: "Sender's Name: "+currentMessage.date.toWeekDayAndDateString(), senderId: currentMessage.senderId), decorationAttributes: ChatItemDecorationAttributes(bottomMargin: 5.0, showsTail: false, canShowAvatar: false))
                decoratedChatItems.append(dateTimeStamp)
            }
            
            // bottomMargin, canShowTail, canShowAvatar, canShowFailedIcon are provided by ChatItemDecorationAttributes
            
            decoratedChatItems.append(DecoratedChatItem(chatItem: chatItem, decorationAttributes: ChatItemDecorationAttributes(bottomMargin: 5.0, showsTail: true, canShowAvatar: showsTail)))
        }
        
        return decoratedChatItems
    }
}
