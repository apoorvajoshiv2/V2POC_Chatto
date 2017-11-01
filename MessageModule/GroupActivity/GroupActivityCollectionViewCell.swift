//
//  GroupActivityCollectionViewCell.swift
//  V2POC_Chatto
//
//  Created by apoorva on 01/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import UIKit

class GroupActivityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var groupActivityLabel: UILabel!
    var text: String? {
        didSet {
            self.groupActivityLabel.text = text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
