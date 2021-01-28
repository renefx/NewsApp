//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Renê Xavier on 27/01/21.
//

import UIKit
import Kingfisher
import SkeletonView

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    func configure (_ viewModel: NewsListElement) {
        self.newsImage.kf.setImage(with: viewModel.image)
        self.title.text = viewModel.title
        self.subtitle.text = viewModel.subtitle
    }
    
    func showSkeleton() {
        newsImage.showAnimatedGradientSkeleton()
        title.showAnimatedGradientSkeleton()
        subtitle.showAnimatedGradientSkeleton()
    }
    
    func hideSkeleton() {
        newsImage.hideSkeleton()
        title.hideSkeleton()
        subtitle.hideSkeleton()
    }
    
}
