//
//  MessageDataSource.swift
//  V2POC_Chatto
//
//  Created by Nitesh Meshram on 10/25/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import Chatto
import CoreData

class MessageDataSource: ChatDataSourceProtocol {
    
    // MARK: - All required things given by protocol
    weak var delegate: ChatDataSourceDelegateProtocol?
    var slidingWindow: SlidingDataSource<ChatItemProtocol>!
    
    
    
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
    private var messages = [ChatItemProtocol]()
    
    //init dataSource with fetchedResultsController with messages for current chat
    init(withController controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.fetchedResultsController = controller
        fetchFromCoreData(controller: controller)
    }
    
    //create message model for each core data object
    private func fetchFromCoreData(controller : NSFetchedResultsController<NSFetchRequestResult>) {
//        for message in controller.fetchedObjects as! [Message]{
//            let message = createTextMessageModelGlobal(message.id!, senderId: message.sender!, text: message.text!, isIncoming: !message.outgoing!.boolValue)
//            self.messages.append(message)
//            
//        }
    }
    
//    private func createTextMessageModelGlobal() -> ChatItemProtocol {
//    
//        
//    }
}
