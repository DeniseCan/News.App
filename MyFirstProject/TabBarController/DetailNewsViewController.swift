//
//  ViewController.swift
//  MyFirstProject
//
//  Created by Alexandr on 20.02.2023.
//

import UIKit

class DetailNewsViewController: UIViewController {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsHeadLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
    var news:[News] = []
    var newsImage:UIImage? = nil
    var newsDate:String = ""
    var newsHeadline:String = ""
    var newsText:String = ""
    var newsIndexInArray:Int = 0
    var delegate:SendSelectedArrayAndDictionaryDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        newsImageView.image = newsImage
        newsDateLabel.text = newsDate
        newsHeadLabel.text = newsHeadline
        newsTextLabel.text = newsText
        for news in self.news {
            if news.newsIndexInArray == self.newsIndexInArray {
                if news.isPressed {
                    self.heartButton.tintColor = .red
                    self.heartButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                } else {
                    self.heartButton.tintColor = .lightGray
                    self.heartButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
                }
            }
        }
    }
    
    @IBAction func addAndRemoveNews(_ sender: UIButton) {
        for news in self.news {
            if news.newsIndexInArray == self.newsIndexInArray {
                news.isPressed = !news.isPressed
                if news.isPressed {
                    sender.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                    sender.tintColor = .red
                    news.newsIndexInArray = newsIndexInArray
                    delegate?.sendSelectedArray(array: self.news)
                    delegate?.sendInfoAboutTheHeart(newsIndexInArray: newsIndexInArray)
                } else {
                    sender.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
                    sender.tintColor = .lightGray
                    delegate?.sendSelectedArray(array: self.news)
                    delegate?.sendInfoAboutTheHeart(newsIndexInArray: newsIndexInArray)
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
