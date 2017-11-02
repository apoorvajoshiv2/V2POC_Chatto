//
//  GroupActivityPresenter.swift
//  V2POC_Chatto
//
//  Created by apoorva on 01/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import Chatto

class GroupActivityModel: ChatItemProtocol {
    let uid: String
    static var chatItemType: ChatItemType {
        return "groupActivity"
    }
    var type: ChatItemType = GroupActivityModel.chatItemType
//    var type: String { return GroupActivityModel.chatItemType }
    var activityType: String
    // Temporarily I have passed only uid as parameter
    init (uid: String, activityType: String) {
        self.uid = uid
        self.activityType = activityType
    }

}

public class GroupActivityPresenterBuilder: ChatItemPresenterBuilderProtocol {
    
    public func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem is GroupActivityModel ? true : false
    }
    
    public func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        assert(self.canHandleChatItem(chatItem))
        return GroupActivityPresenter(
            groupActivity: chatItem as! GroupActivityModel
        )
    }
    
    public var presenterType: ChatItemPresenterProtocol.Type {
        return GroupActivityPresenter.self
    }
}

class GroupActivityPresenter: ChatItemPresenterProtocol {
    
    let groupActivity: GroupActivityModel
    init (groupActivity: GroupActivityModel) {
        self.groupActivity = groupActivity
    }
    
    static func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "GroupActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GroupActivityCollectionViewCell")
    }
    
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupActivityCollectionViewCell", for: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let activityCell = cell as? GroupActivityCollectionViewCell else {
            assert(false, "expecting group activity cell")
            return
        }
        
        activityCell.text = self.activityText()
    }
    
    func activityText() -> String {
        switch self.groupActivity.activityType {
        case "room_changed_description":
            return "Updated group's icon"
        case "au":
            return "Added you"
        case "ru":
            return "Removed you"
        case "r":
            return "Updated group name from"
        case "rd":
            return "Deleted this group"
        default:
            return "Added you"
        }
    }
    
    var canCalculateHeightInBackground: Bool {
        return true
    }
    
    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        return 13
    }
}

