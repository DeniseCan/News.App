//
//  News.swift
//  MyFirstProject
//
//  Created by Alexandr on 22.02.2023.
//

import UIKit

class News {
    
    var newsImage: UIImage?
    var newsHeadline:String?
    var newsText:String?
    var newsDate:String?
    var newsIndexInArray:Int? = nil
    var isPressed:Bool = false
    
    init(newsImage:UIImage, newsHeadline:String, newsText:String, newsDate:String) {
        self.newsImage = newsImage
        self.newsHeadline = newsHeadline
        self.newsText = newsText
        self.newsDate = newsDate
    }
}
