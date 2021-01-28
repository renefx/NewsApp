//
//  ImageCornerRadius.swift
//  NewsApp
//
//  Created by Renê Xavier on 27/01/21.
//

import Foundation
import UIKit

class ImageCornerRadius: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews(){
        super.layoutSubviews()
        layer.cornerRadius = 6
        clipsToBounds = true
    }
}
