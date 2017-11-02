//
//  SenderTimestampCollectionViewCell.swift
//  V2POC_Chatto
//
//  Created by apoorva on 03/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import UIKit

class SenderTimestampCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeStampLabel: UILabel!
    var text: String = "" {
        didSet {
            if oldValue != text {
                self.timeStampLabel.text = text
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
