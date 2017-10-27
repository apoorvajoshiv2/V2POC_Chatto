//
//  MessageSender.swift
//  V2POC_Chatto
//
//  Created by Nitesh Meshram on 10/27/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

public protocol V2MessageModelProtocol: MessageModelProtocol {
    var status: MessageStatus { get set }
}

public class MessageSender {
    
    public var onMessageChanged: ((_ message: V2MessageModelProtocol) -> Void)?
    
    public func sendMessages(_ messages: [V2MessageModelProtocol]) {
        for message in messages {
            self.v2MessageStatus(message)
        }
    }
    
    public func sendMessage(_ message: V2MessageModelProtocol) {
        self.v2MessageStatus(message)
    }
    
    private func v2MessageStatus(_ message: V2MessageModelProtocol) {
        switch message.status {
        case .success:
            break
        case .failed:
            self.updateMessage(message, status: .sending)
            self.v2MessageStatus(message)
        case .sending:
            switch arc4random_uniform(100) % 5 {
            case 0:
                if arc4random_uniform(100) % 2 == 0 {
                    self.updateMessage(message, status: .failed)
                } else {
                    self.updateMessage(message, status: .success)
                }
            default:
                let delaySeconds: Double = Double(arc4random_uniform(1200)) / 1000.0
                let delayTime = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.v2MessageStatus(message)
                }
            }
        }
    }
    
    private func updateMessage(_ message: V2MessageModelProtocol, status: MessageStatus) {
        if message.status != status {
            message.status = status
            self.notifyMessageChanged(message)
        }
    }
    
    private func notifyMessageChanged(_ message: V2MessageModelProtocol) {
        self.onMessageChanged?(message)
    }
}
