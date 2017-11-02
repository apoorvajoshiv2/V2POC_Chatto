//
//  SenderTimestampModel.swift
//  V2POC_Chatto
//
//  Created by apoorva on 03/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import Chatto

class SenderTimestampModel: ChatItemProtocol {
    let uid: String
    let type: String = SenderTimestampModel.chatItemType
    let date: String
    let senderId: String
    
    static var chatItemType: ChatItemType {
        return "SenderTimeSeparator"
    }
    
    init(uid: String, date: String, senderId: String) {
        self.date = date
        self.uid = uid
        self.senderId = senderId
    }
    
}

extension Date {
    // Have a time stamp formatter to avoid keep creating new ones. This improves performance
    private static let weekdayAndDateStampDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "MM/dd/yy 'at' h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        return dateFormatter
    }()
    
    func toWeekDayAndDateString() -> String {
        return Date.weekdayAndDateStampDateFormatter.string(from: self)
    }
}
