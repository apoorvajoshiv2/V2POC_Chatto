//
//  MediaTextCollectionViewCell.swift
//  V2POC_Chatto
//
//  Created by apoorva on 06/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions

class MediaTextCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playButton: UIImageView!
    @IBOutlet weak var viewForImage: UIView!
    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var failedButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var uploadingFailedButton: UIButton!
    @IBOutlet weak var heightForContainerView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func mediaTapped(_ sender: Any) {
        print("Media is tapped")
    }
    
    @IBAction func uploadingFailedButtonTapped(_ sender: Any) {
        print("Retry button tapped")
    }
    
    public var photoMessageStyle: PhotoBubbleViewStyleProtocol! {
        didSet {
            
        }
    }
    
    public var mediaMessageStyle: BaseMessageCollectionViewCellStyleProtocol! {
        didSet {
            self.photoMessageStyle = mediaMessageStyle as! PhotoBubbleViewStyleProtocol
        }
    }
    
}
