//
//  RoundedImage.swift
//  NewsApp
//
//  Created by Renê Xavier on 25/01/21.
//

import UIKit

class RoundedImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews(){
        super.layoutSubviews()
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
