//
//  HTTPCatCollectionViewCell.swift
//  StatefulViewController
//
//  Created by Hussein Work on 21/01/2021.
//

import UIKit

class HTTPCatCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = 12
        clipsToBounds = true
    }
}

