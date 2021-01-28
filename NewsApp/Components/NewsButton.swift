//
//  NewsButton.swift
//  NewsApp
//
//  Created by Renê Xavier on 25/01/21.
//

import UIKit

class NewsButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
    }


    override func layoutSubviews(){
        super.layoutSubviews()
        layer.cornerRadius = 8
        backgroundColor = UIColor(named: "Primary")
        titleLabel?.font.withSize(20.0)
        setTitleColor(UIColor(named: "Accent"), for: .normal)
    }
}
