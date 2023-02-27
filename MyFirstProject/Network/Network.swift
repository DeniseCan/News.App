//
//  Network.swift
//  MyFirstProject
//
//  Created by Alexandr on 25.02.2023.
//

import Foundation
import NewsAPISwift

func getNewsFromNewsAPI(completion: @escaping ([News]) -> Void) {
    
    let newsAPI = NewsAPI(apiKey: "13a8e4dfb3ce42b0b0992123abe8d029")
    var newsArray:[News] = []
    
    newsAPI.getTopHeadlines(q: "News", pageSize: 99) { result in

        switch result {
        case .success(let articles):
            for article in articles {
                if article.articleDescription != Optional("") && article.articleDescription != nil {
                    let newsImage:UIImage = UIImage(named: "Picture")!
                    let newsHeadline:String = article.title
                    let newsText:String = article.articleDescription!
                    /*Преобразуем строку с датой в формат даты "yyyy-MM-dd HH:mm:ss Z",
                    а затем в формат "dd MMMM" для того, чтобы получить нужную нам строку
                    с текстовой датой*/
                    let dateString = "\(article.publishedAt)"
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        let date = dateFormatter.date(from: dateString)
                        dateFormatter.dateFormat = "dd MMMM"
                        let newsDate:String = dateFormatter.string(from: date!)
                    //Создаем экземпляр News
                    let news = News(newsImage: newsImage, newsHeadline: newsHeadline, newsText: newsText, newsDate: newsDate)
                    //И добавляем его в массив новостей
                    newsArray.append(news)
                }
            }
            //Добавляем вызов замыкания с полученным массивом новостей
            completion(newsArray)
        case .failure( _):
            print("Response failed!!")
        }
    }
}
