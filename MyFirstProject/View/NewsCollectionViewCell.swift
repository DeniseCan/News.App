//
//  NewsCollectionViewCell.swift
//  MyFirstProject
//
//  Created by Alexandr on 22.02.2023.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsHeadline: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var heartButton: UIButton!

    func customizationCell (newsImage: UIImage, newsDate: String, newsHeadline:String, newsText:String, colorHeartButton: UIColor, imageHeardButton:UIImage, tagHeartButton: Int) {
        self.newsImage.image = newsImage
        self.newsDate.text = newsDate
        self.newsHeadline.text = newsHeadline
        self.newsText.text = newsText
        self.heartButton.tag = tagHeartButton
        self.heartButton.tintColor = colorHeartButton
        self.heartButton.setBackgroundImage(imageHeardButton, for: .normal)
    }
}


