//
//  FNSPhotoMessageModel.swift
//  V2POC_Chatto
//
//  Created by apoorva on 03/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

public class FNSPhotoMessageModel: PhotoMessageModel<MessageModel>, V2MessageModelProtocol {
    public override init(messageModel: MessageModel, imageSize: CGSize, image: UIImage) {
        super.init(messageModel: messageModel, imageSize: imageSize, image: image)
    }
    
    public var status: MessageStatus {
        get {
            return self._messageModel.status
        }
        set {
            self._messageModel.status = newValue
        }
    }
}

