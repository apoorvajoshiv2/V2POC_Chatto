//
//  MessageChatInputBarAppearance.swift
//  V2POC_Chatto
//
//  Created by apoorva on 27/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import UIKit

public struct MessageChatInputBarAppearance {
    public struct SendButtonAppearance {
        public var font = UIFont.systemFont(ofSize: 16)
        public var insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        public var title = ""
        public var borderColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    }
    
    public struct TextInputAppearance {
        public var font = UIFont.systemFont(ofSize: 12)
        public var textColor = UIColor.black
        public var tintColor: UIColor?
        public var borderColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        public var borderWidth: CGFloat = 2.0
        public var placeholderFont = UIFont.systemFont(ofSize: 12)
        public var placeholderColor = UIColor.gray
        public var placeholderText = ""
        public var textInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    public var sendButtonAppearance = SendButtonAppearance()
    public var textInputAppearance = TextInputAppearance()
    
    public init() {}
}

