//
//  MediaTextMessageModel.swift
//  V2POC_Chatto
//
//  Created by apoorva on 06/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class MediaTextMessageModel: ChatItemProtocol {
    let uid: String
    static var chatItemType: ChatItemType {
        return "mediaText"
    }
    var status: MessageStatus
    var type: ChatItemType = MediaTextMessageModel.chatItemType
    var mediaThumbnail: String
    var mediaText: String
    var isVimeo = false
    var isMediaText = false
    var isIncoming = false
    // Temporarily I have passed only uid as parameter
    init (uid: String, image: String, text: String, isVimeo: Bool, isMediaText: Bool, status: MessageStatus, isIncoming: Bool) {
        self.uid = uid
        self.mediaThumbnail = image
        self.mediaText = text
        self.isVimeo = isVimeo
        self.isMediaText = isMediaText
        self.status = status
        self.isIncoming = isIncoming
    }
    
}

public class MediaTextMessagePresenterBuilder: ChatItemPresenterBuilderProtocol {
    
    public func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem is MediaTextMessageModel
    }
    
    public func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        assert(self.canHandleChatItem(chatItem))
        
        return MediaTextMessagePresenter(mediaTextMessageModel: chatItem as! MediaTextMessageModel)
    }
    
    public var presenterType: ChatItemPresenterProtocol.Type {
        return MediaTextMessagePresenter.self
    }
}

class MediaTextMessagePresenter: ChatItemPresenterProtocol {
    let mediaTextMessageModel: MediaTextMessageModel
    var maximumWidth: CGFloat = 0.0
    init (mediaTextMessageModel: MediaTextMessageModel) {
        self.mediaTextMessageModel = mediaTextMessageModel
    }
    
    static func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "MediaTextCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MediaTextCollectionViewCell")
    }
    
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaTextCollectionViewCell", for: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let mediaCell = cell as? MediaTextCollectionViewCell else {
            assert(false, "expecting media cell")
            return
        }
        mediaCell.containerView.layer.cornerRadius = 20.0
        mediaCell.frame.size.width = 232.0
        mediaCell.frame.origin.x = mediaTextMessageModel.isIncoming ? mediaCell.frame.origin.x : self.maximumWidth - mediaCell.frame.size.width
        
        // Convert back to image from data
        
        let data =  Data(base64Encoded: self.mediaTextMessageModel.mediaThumbnail as String, options: NSData.Base64DecodingOptions())
        if let data1 = data {
            mediaCell.imageView.image = UIImage(data: data1)
        } else {
            mediaCell.imageView.image = UIImage(named: self.mediaTextMessageModel.mediaThumbnail)
        }
        
        if self.mediaTextMessageModel.isVimeo {
            mediaCell.playButton.isHidden = false
        } else {
            mediaCell.playButton.isHidden = true
        }
        
        if mediaTextMessageModel.isMediaText {
            mediaCell.textLabel.isHidden = false
            mediaCell.textLabel.text = mediaTextMessageModel.mediaText
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(roundedRect: mediaCell.imageView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
            
            mediaCell.imageView.layer.mask = maskLayer
            mediaCell.viewForImage.layer.mask = maskLayer
        } else {
//            mediaCell.textLabel.text = ""
            mediaCell.textLabel.isHidden = true
            mediaCell.imageView.layer.cornerRadius = 20.0
            mediaCell.viewForImage.layer.cornerRadius = 20.0
        }
    }
    
    var canCalculateHeightInBackground: Bool {
        return true
    }
    
    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        var height: CGFloat = 0.0
        self.maximumWidth = width
        print("height",mediaTextMessageModel.mediaText.height(withConstrainedWidth: 180.0, font: UIFont.systemFont(ofSize: 12.0)))
        if mediaTextMessageModel.isMediaText {
            let heightOfLabel = mediaTextMessageModel.mediaText.height(withConstrainedWidth: 180.0, font: UIFont.systemFont(ofSize: 12.0))
            height = 162 + heightOfLabel + 20
        } else {
            height = 162
        }
        return height
    }
    
    func calculateLayout(photoSize: CGSize) {
//        let photoSize = photoSize
//        let photoFrame = CGRect(origin: CGPoint.zero, size: photoSize)
//        let offsetX: CGFloat = 0.5 * (mediaTextMessageModel.isIncoming ? 1.0 : -1.0)
//        self.visualCenter = photoFrame.bma_center.bma_offsetBy(dx: offsetX, dy: 0)
//        self.size = photoSize
    }

    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(boundingBox.height)
    }
}

