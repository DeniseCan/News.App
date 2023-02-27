//
//  NewsViewController.swift
//  MyFirstProject
//
//  Created by Alexandr on 20.02.2023.
//

import UIKit
import CoreData

class NewsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    //Массивы для данных на вкладку "Новости"
    var news:[News] = []
    var loadNews:[News] = []
    
    //Переменные для перехода на экраны отдельной новости и на вкладку "Избранное"
    var newsImage: UIImage?
    var newsHeadline:String = ""
    var newsText:String = ""
    var newsDate:String = ""
    var indexPath:IndexPath?
    var delegate: SendSelectedArrayAndDictionaryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*Создаем индексацию элементов news, для удобного поиска и извлечения данных из них в процесса
        переходов на другие экраны и загрузки данных из Core Data*/
        makeArray(array: news)
        
        //Выполняем загрузку данных пользователя из базы данных
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<FavoriteNews> = FavoriteNews.fetchRequest()
        do {
            let favoriteNews = try context.fetch(fetchRequest)
            for news in favoriteNews {
                let imageString = news.newsImage
                let date = news.newsDate
                let headLine = news.newsHeadline
                let text = news.newsText
                let isPressed = news.isPressed
                let indexInArray = news.newsIndexInArray
                let loadNews = News(newsImage: UIImage(named: imageString!)!, newsHeadline: headLine!, newsText: text!, newsDate: date!)
                loadNews.newsIndexInArray = Int(indexInArray)
                loadNews.isPressed = isPressed
                self.loadNews.append(loadNews)
            }
        } catch {
            print("Failed user: \(error)")
        }
        
        /*Находим соответствие по свойству newsIndexInArray между загружаемым массивом loadNews
         и текущим News для передачи данных*/
        if !loadNews.isEmpty && loadNews.count <= news.count {
            for (index, loadItem) in loadNews.enumerated() {
                for item in self.news {
                    if item.newsIndexInArray == loadItem.newsIndexInArray {
                        self.news[loadItem.newsIndexInArray!] = loadNews[index]
                    }
                }
            }
        } else {
            news.insert(contentsOf: loadNews, at: 0)
        }
    }
    
    private func makeArray(array:Array<News>) {
        //Если новостей нет или проблемы с загрузкой, массив News не формируем
        if !news.isEmpty {
            for index in 0...news.count - 1 {
                news[index].newsIndexInArray = index
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*Подготавливаем selectedNewsViewController, извлекая его значение из tabBarController, далее с помощью метода
        proccesedData(...) класса SelectedNewsViewController телепортируем данные на вкладку Избранные*/
        guard let tabBarController = self.tabBarController else { return }
        guard let navigationViewConroller = tabBarController.viewControllers![2] as? NavigationViewController else { return }
        guard let selectedNewsViewController = navigationViewConroller.viewControllers[0] as? SelectedNewsViewController else { return }
        selectedNewsViewController.proccesedData(array: self.news)
    }
    
    func proccesedData(array:[News]) {
        self.news = array
    }
    
    /*Добавляем новость в избранное или убираем ее, в зависимости от нажатия на кнопку с символом сердца меняем
    image кнопки на "heart" либо "heart.fill", а также меняем ее цвет*/
    @IBAction func addAndRemoveNews(_ sender: UIButton) {
        
        news[sender.tag].isPressed = !news[sender.tag].isPressed
        
        if news[sender.tag].isPressed {
            sender.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            sender.tintColor = .red
            news[sender.tag].newsIndexInArray = sender.tag
        } else {
            sender.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            sender.tintColor = .lightGray
            //Осуществляем поиск новости в массиве newsSelected по свойству class'а News - newsIndexInArray
            for news in news {
                if news.newsIndexInArray == sender.tag {
                    news.newsIndexInArray = nil
                }
            }
        }
    }
}

extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 30)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewsCollectionViewCell
        newsImage = news[indexPath.item].newsImage ?? UIImage(named: "launchScreen")
        newsDate = news[indexPath.item].newsDate ?? "14.02.2023"
        newsHeadline = news[indexPath.item].newsHeadline ?? "Top news"
        newsText = news[indexPath.item].newsText ?? "Whats up, Whats up, Whats up, Whats up, Whats up"
        
        var colorHeartButton:UIColor
        var imageHeardButton:UIImage
        
        if news[indexPath.item].isPressed {
            colorHeartButton = .red
            imageHeardButton = UIImage(systemName:"heart.fill")!
        } else {
            colorHeartButton = .lightGray
            imageHeardButton = UIImage(systemName:"heart")!
        }
        
        cell.customizationCell(newsImage: newsImage!, newsDate: newsDate, newsHeadline: newsHeadline, newsText: newsText, colorHeartButton: colorHeartButton, imageHeardButton: imageHeardButton, tagHeartButton: indexPath.item)

        return cell
    }
    
    func  collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewsCollectionViewCell
        performSegue(withIdentifier: "showDetailNewsFromNews", sender: cell)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailNewsViewController = segue.destination as? DetailNewsViewController, segue.identifier == "showDetailNewsFromNews" {
            detailNewsViewController.newsImage = newsImage
            detailNewsViewController.newsDate = newsDate
            detailNewsViewController.newsHeadline = newsHeadline
            detailNewsViewController.newsText = newsText
            detailNewsViewController.news = self.news
            detailNewsViewController.newsIndexInArray = indexPath!.item
            detailNewsViewController.delegate = self
        }
    }
}

extension NewsViewController: SendSelectedArrayAndDictionaryDelegate {
    func sendInfoAboutTheHeart(newsIndexInArray: Int) {}
    func sendSelectedArray(array:[News]) {
        self.news = array
    }
}
