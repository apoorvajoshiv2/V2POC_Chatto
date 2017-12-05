//
//  MessageDataSource.swift
//  V2POC_Chatto
//
//  Created by Nitesh Meshram on 10/25/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import CoreData

import Chatto
import ChattoAdditions

class MessageDataSource: ChatDataSourceProtocol {
    
    // MARK: - All required things given by protocol
    weak var delegate: ChatDataSourceDelegateProtocol?
    var slidingWindow: SlidingDataSource<ChatItemProtocol>!
    
    private var messages = [ChatItemProtocol]()
    
    //    init(messages: [ChatItemProtocol], pageSize: Int) {
    //        self.slidingWindow = SlidingDataSource(items: messages, pageSize: pageSize)
    //    }
    //
    
    lazy var messageSender: MessageSender = {
        let sender = MessageSender()
        sender.onMessageChanged = { [weak self] (message) in
            guard let sSelf = self else { return }
            sSelf.delegate?.chatDataSourceDidUpdate(sSelf)
        }
        return sender
    }()
    
    var hasMoreNext: Bool {
        //        return self.slidingWindow.hasMore()
        return true
    }
    
    var hasMorePrevious: Bool {
        //        return self.slidingWindow.hasPrevious()
        return true
    }
    
    var chatItems: [ChatItemProtocol] {
        //        return self.slidingWindow.itemsInWindow
        return self.messages //return filled messages
    }
    
    func loadNext() {
        /* self.slidingWindow.loadNext()
         self.slidingWindow.adjustWindow(focusPosition: 1, maxWindowSize: self.preferredMaxWindowSize)
         self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
         
         */
    }
    
    func loadPrevious() {
        /*
         self.slidingWindow.loadPrevious()
         self.slidingWindow.adjustWindow(focusPosition: 0, maxWindowSize: self.preferredMaxWindowSize)
         self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
         */
    }
    
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion:(_ didAdjust: Bool) -> Void) {
        /*
         let didAdjust = self.slidingWindow.adjustWindow(focusPosition: focusPosition, maxWindowSize: preferredMaxCount ?? self.preferredMaxWindowSize)
         completion(didAdjust)
         */
    }
    
    
    
    
    // MARK: - All customization by V2Solutions
    
    let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    //    private var messages = [ChatItemProtocol]()
    
    //    func createMessages () {
    //        let messageFactory = MockMessageFactory.sharedInstance
    //        let allMessageData =  messageFactory.getAllMessages()
    //        for message in allMessageData as! [Message] {
    //
    //            let message = messageFactory.createTextMessageModel(message.id!, text: message.text!, isIncoming: false)
    //            self.messages.append(message)
    //        }
    //    }
    
    
    //init dataSource with fetchedResultsController with messages for current chat
    init(withController controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.fetchedResultsController = controller
        fetchFromCoreData(controller: controller)
    }
    
    
    
    //create message model for each core data object
    private func fetchFromCoreData(controller : NSFetchedResultsController<NSFetchRequestResult>) {
        for message in controller.fetchedObjects as! [Message]{
            //            print("Message details \(message.id), \(message.text)")
            //            let message = createTextMessageModelGlobal(message.id!,
            //                                                       senderId: message.sender!,
            //                                                       text: message.text!,
            //                                                       isIncoming: false)
            
            print(" \(String(describing: message.mediaType))"  ,"\(String(describing: message.text))")
            if message.mediaType == "text" {
                let message = createTextMessageModelGlobal(messageId: message.id!,
                                                           messageText: message.text!,
                                                           messageSenderId: "1",
                                                           isIncoming: false)
                self.messages.append(message)
                
            } else if message.mediaType == "groupActivity" {
                let groupActivityMessage = createGroupActivityModelGlobal(messageId: message.id!, messageText: message.text!)
                self.messages.append(groupActivityMessage)
            } else if message.mediaType == "image" {
                let image = UIImage(named: message.text!)!
                let size = CGSize(width: 200 , height: 150)
                let isIncomingMessage = arc4random_uniform(2) == 0
                let photoMessage = createPhotoMessageModel(message.id!, image: image, size: size, isIncoming: isIncomingMessage)
                self.messages.append(photoMessage)
            } else if message.mediaType == "media" {
                let isIncomingMessage = arc4random_uniform(2) == 0
                let isMediaText = arc4random_uniform(2) == 0
                let mediaMessage: MediaMessageModel
                if (message.mediaUrl != nil) {
                    mediaMessage = createMediaMessageModel(messageId: message.id!, image: message.mediaUrl!, text: message.text!, isIncoming: isIncomingMessage, isVimeo: isIncomingMessage, isMediaText: isMediaText)
                } else {
                    // Default image
                    mediaMessage = createMediaMessageModel(messageId: message.id!, image: "pic-test-1", text: message.text!, isIncoming: isIncomingMessage, isVimeo: isIncomingMessage, isMediaText: isMediaText)
                }
                
                
//                let messageModel = createMessageModel(message.id!, isIncoming: isIncomingMessage, type: SenderTimestampModel.chatItemType)
//                let dateTimeStamp = SenderTimestampModel(uid: "\(messageModel.uid)-time-separator", date: "Sender's Name: "+messageModel.date.toWeekDayAndDateString(), senderId: messageModel.senderId)
//                self.messages.append(dateTimeStamp)
                self.messages.append(mediaMessage)
            }
            
        }
    }
    
    //first we create message model and then core data object for that message
    func addTextMessage(text: String)//, sender: String,  outgoing: Bool) {
    {
        let uid = NSUUID().uuidString
        let sender = "1"
        let outgoing = true
        
        
        //        self.addCoreDataMessage(text: text, sender: sender, outgoing: outgoing, id: uid, timestamp: NSDate())
        self.addCoreDataMessage(text: text, imageUrl: "", mediaType: "text", sender: sender, outgoing: outgoing, id: uid, timestamp: NSDate()) { (result: String) in
            
            let message = createTextMessageModelGlobal(messageId: uid, messageText: text, messageSenderId: sender, isIncoming: !outgoing)
            messageSender.sendMessage(message)
            self.messages.append(message)
            //            self.slidingWindow.insertItem(message, position: .bottom)
            delegate?.chatDataSourceDidUpdate(self)
        }
        
        
    }
    
    func reuestAPI() {
        
    }
    
    func addPhotoMessage(image: UIImage)//, sender: String,  outgoing: Bool) {
    {
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        let imageUrl = imageData!.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        
        let uid = NSUUID().uuidString
        let sender = "1"
        let outgoing = true
        self.addCoreDataMessage(text: "", imageUrl: imageUrl, mediaType: "media", sender: sender, outgoing: outgoing, id: uid, timestamp: NSDate()) { (result: String) in
            
            let message = createMediaMessageModel(messageId: uid, image: imageUrl, text: "", isIncoming: false, isVimeo: false, isMediaText: false)
            messageSender.sendMessage(message)
            self.messages.append(message)
            //            self.slidingWindow.insertItem(message, position: .bottom)
            delegate?.chatDataSourceDidUpdate(self)
        }
    }
    
    private func addCoreDataMessage(text: String, imageUrl: String, mediaType: String, sender: String, outgoing: Bool, id: String, timestamp: NSDate, completion: (_ result: String) -> Void) {
        let context = self.fetchedResultsController.managedObjectContext
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.text = text
        message.mediaUrl = imageUrl
        message.createdOn = timestamp
        message.mediaType = mediaType
        //        message.outgoing
        //        message.sender = sender
        //        message.outgoing = NSNumber(bool: outgoing)
        message.id = id
        //        message.timestamp = timestamp
        
        do {
            try context.save()
            completion(message.id!)
        } catch let error as NSError {
            print(error)
        }
    }
    
    // MARK: - Below are default methods. May be we have to modify below methods according to FNS
    
    func createTextMessageModelGlobal(messageId: String, messageText: String, messageSenderId: String, isIncoming: Bool) -> FNSTextMessageModel {
        let isIncomingMessage = arc4random_uniform(2) == 0
        let messageModel = createMessageModel(messageId, isIncoming: isIncomingMessage, type: TextMessageModel<MessageModel>.chatItemType)
        let textMessageModel = FNSTextMessageModel(messageModel: messageModel, text: messageText)
        return textMessageModel
    }
    
    func createMessageModel(_ uid: String, isIncoming: Bool, type: String) -> MessageModel {
        let senderId = isIncoming ? "1" : "2"
        let messageStatus = isIncoming || arc4random_uniform(100) % 3 == 0 ? MessageStatus.success : .failed
        let messageModel = MessageModel(uid: uid, senderId: senderId, type: type, isIncoming: isIncoming, date: Date(), status: messageStatus)
        return messageModel
    }
    
    func createGroupActivityModelGlobal(messageId: String, messageText: String) -> GroupActivityModel {
        let groupActivityMessageModel = GroupActivityModel(uid: messageId, activityType: messageText)
        return groupActivityMessageModel
    }
    
    func createPhotoMessageModel(_ uid: String, image: UIImage, size: CGSize, isIncoming: Bool) -> FNSPhotoMessageModel {
        let messageModel = createMessageModel(uid, isIncoming: isIncoming, type: PhotoMessageModel<MessageModel>.chatItemType)
        let photoMessageModel = FNSPhotoMessageModel(messageModel: messageModel, imageSize: size, image: image)
        return photoMessageModel
    }
    
    func createMediaMessageModel(messageId: String, image: String, text: String, isIncoming: Bool, isVimeo: Bool, isMediaText: Bool) -> MediaMessageModel {
        let messageModel = createMessageModel(messageId, isIncoming: isIncoming, type: MediaTextMessageModel<MessageModel>.chatItemType)
//        let messageStatus = isIncoming || arc4random_uniform(100) % 3 == 0 ? MessageStatus.success : .failed
        let mediaMessageModel = MediaMessageModel(messageModel: messageModel, uid: messageId, image: image, text: text, isVimeo: isVimeo, isMediaText: isMediaText)
        return mediaMessageModel
    }
    
}
