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

public protocol PhotoMessageModelProtocol: DecoratedMessageModelProtocol {
    var mediaThumbnail: String { get }
    var mediaText: String { get }
    var isVimeo: Bool { get }
    var isMediaText: Bool { get }
}

open class MediaTextMessageModel<MessageModelT: MessageModelProtocol>: PhotoMessageModelProtocol {
    public var isMediaText: Bool
    public var isVimeo: Bool
    public var mediaText: String
    public var mediaThumbnail: String
    public var messageModel: MessageModelProtocol {
        return self._messageModel
    }
    public let _messageModel: MessageModelT
    public let uid: String
    static var chatItemType: ChatItemType {
        return "mediaText"
    }
//    public var status: MessageStatus
    public var type: ChatItemType = MediaTextMessageModel.chatItemType
    
    public init (messageModel: MessageModelT, uid: String, image: String, text: String, isVimeo: Bool, isMediaText: Bool) {
        self._messageModel = messageModel
        self.uid = uid
        self.mediaThumbnail = image
        self.mediaText = text
        self.isVimeo = isVimeo
        self.isMediaText = isMediaText
    }
}

public class MediaMessageModel: MediaTextMessageModel<MessageModel>, V2MessageModelProtocol {
    public var date = Date()

    public var senderId = "1"

    public override init(messageModel: MessageModel, uid: String, image: String, text: String, isVimeo: Bool, isMediaText: Bool) {
        super.init(messageModel: messageModel, uid: uid, image: image, text: text, isVimeo: isVimeo, isMediaText: isMediaText)
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

//class MediaViewMessageModel: ChatItemProtocol {
//        
//}

public class MediaTextMessagePresenterBuilder: ChatItemPresenterBuilderProtocol {
    public lazy var baseCellStyle: BaseMessageCollectionViewCellStyleProtocol = BaseMessageCollectionViewCellDefaultStyle()
    public func canHandleChatItem(_ chatItem: ChatItemProtocol) -> Bool {
        return chatItem is MediaMessageModel
    }
    
    public func createPresenterWithChatItem(_ chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        assert(self.canHandleChatItem(chatItem))
        return MediaTextMessagePresenter(mediaTextMessageModel: chatItem as! MediaMessageModel, baseCellStyle: baseCellStyle)
    }
    
    public var presenterType: ChatItemPresenterProtocol.Type {
        return MediaTextMessagePresenter.self
    }
}

class MediaTextMessagePresenter: ChatItemPresenterProtocol {
    let mediaTextMessageModel: MediaMessageModel
    let cellStyle: BaseMessageCollectionViewCellStyleProtocol
    var maximumWidth: CGFloat = 0.0
    
    public private(set) lazy var failedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(failedButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func failedButtonTapped(_ sender: UIButton) {
        print("Fail icon tapped")
    }
    
    init (mediaTextMessageModel: MediaMessageModel, baseCellStyle: BaseMessageCollectionViewCellStyleProtocol) {
        self.mediaTextMessageModel = mediaTextMessageModel
        cellStyle = baseCellStyle
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
        
        print("status of message",mediaTextMessageModel.status)
        if mediaTextMessageModel.isIncoming == true || (mediaTextMessageModel.isIncoming == false && mediaTextMessageModel.status != MessageStatus.failed) {
            mediaCell.failedButtonWidthConstraint.constant = 0
            mediaCell.uploadingFailedButton.isHidden = true
            mediaCell.frame.size.width = 232.0
        } else {
            mediaCell.uploadingFailedButton.isHidden = false
            mediaCell.failedButtonWidthConstraint.constant = 44
            mediaCell.frame.size.width = 276.0
        }
        mediaCell.frame.origin.x = mediaTextMessageModel.isIncoming ? mediaCell.frame.origin.x : self.maximumWidth - mediaCell.frame.size.width
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

