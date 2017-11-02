//
//  SenderTimestampPresenter.swift
//  V2POC_Chatto
//
//  Created by apoorva on 03/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import Chatto

public class SenderTimestampPresenterBuilder: ChatItemPresenterBuilderProtocol {
    
    public func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem is SenderTimestampModel
    }
    
    public func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        assert(self.canHandleChatItem(chatItem))
        return SenderTimestampPresenter(senderTimestampModel: chatItem as! SenderTimestampModel)
    }
    
    public var presenterType: ChatItemPresenterProtocol.Type {
        return SenderTimestampPresenter.self
    }
}

class SenderTimestampPresenter: ChatItemPresenterProtocol {
    
    let senderTimestampModel: SenderTimestampModel
    init (senderTimestampModel: SenderTimestampModel) {
        self.senderTimestampModel = senderTimestampModel
    }
    
    static func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "SenderTimestampCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SenderTimestampCollectionViewCell")
    }
    
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderTimestampCollectionViewCell", for: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let senderTimestampCell = cell as? SenderTimestampCollectionViewCell else {
            assert(false, "expecting senderTimestampCell")
            return
        }
        
        senderTimestampCell.text = self.senderTimestampModel.date
    }
    
    var canCalculateHeightInBackground: Bool {
        return true
    }
    
    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        return 12
    }
}
