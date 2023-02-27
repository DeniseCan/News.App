//
//  SelectedNewsViewController.swift
//  MyFirstProject
//
//  Created by Alexandr on 23.02.2023.
//

import UIKit
import CoreData

class SelectedNewsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    //Массив работы с вью на вкладке "Избранные"
    var newsSelected:[News] = []
    //Остальные переменные для функционирования вью
    var news:[News] = []
    var newsImage: UIImage?
    var newsHeadline:String = ""
    var newsText:String = ""
    var newsDate:String = ""
    var indexPath:IndexPath?
    var newsIndexInArray:Int?

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //Удаляем данные из Core Data при каждом переходе на вкладку
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<FavoriteNews> = FavoriteNews.fetchRequest()
            if let results = try? context.fetch(fetchRequest) {
                for object in results { context.delete(object) }
            }
        CoreDataManager.shared.saveContext()

        //Обнуляем массив прикаждом переходе
        newsSelected = []
        //и формируем новый newsSelected
        for news in self.news{
            if news.isPressed {
                newsSelected.append(news)
            }
        }
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*Подготавливаем newsViewController, извлекая его значение из tabBarController, далее с помощью метода
        proccesedData(...) класса SelectedNewsViewController телепортируем данные на вкладку Новости*/
        guard let tabBarController = self.tabBarController else { return }
        guard let navigationViewConroller = tabBarController.viewControllers![0] as? NavigationViewController else { return }
        guard let newsViewController = navigationViewConroller.viewControllers[0] as? NewsViewController else { return }
        newsViewController.proccesedData(array: self.news)
        
        //Сохраняем News в базу данных
        for news in self.newsSelected {
            let selectedNews = FavoriteNews(context: CoreDataManager.shared.context)
            selectedNews.newsImage = "Picture"
            selectedNews.newsDate = news.newsDate
            selectedNews.newsHeadline = news.newsHeadline
            selectedNews.newsText = news.newsText
            selectedNews.isPressed = news.isPressed
            selectedNews.newsIndexInArray = Int16(news.newsIndexInArray!)
            print(selectedNews)
            CoreDataManager.shared.context.insert(selectedNews)
            CoreDataManager.shared.saveContext()
        }
    }
    
    func proccesedData(array:[News]) {
        self.news = array
    }
    
    private func reloadCollectionView(newsIndexInArray:Int?) {
        //Осуществляем поиск новости в массиве newsSelected по свойству class'а News - newsIndexInArray
            for (index, newSelected) in self.newsSelected.enumerated() {
                if newSelected.newsIndexInArray == newsIndexInArray {
                    self.news[newsIndexInArray!].isPressed = !self.news[newsIndexInArray!].isPressed
                    self.newsSelected.remove(at: index)
                }
            }
        collectionView.reloadData()
    }
    
    /*При нажатии на button c image("heart.fill") убираем новость с вакладки Избранное,
    а также удаляем соответствующий News из массива newSelected*/
    @IBAction func addAndRemoveNews(_ sender: UIButton) {
        
        sender.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        sender.tintColor = .lightGray
        self.reloadCollectionView(newsIndexInArray:newsSelected[sender.tag].newsIndexInArray)
        
    }
}

extension SelectedNewsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 30) / 2
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsSelected.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewsCollectionViewCell
        newsImage = newsSelected[indexPath.item].newsImage ?? UIImage(named: "launchScreen")
        newsDate = newsSelected[indexPath.item].newsDate ?? "14.02.2023"
        newsHeadline = newsSelected[indexPath.item].newsHeadline ?? "Top news"
        newsText = newsSelected[indexPath.item].newsText ?? "Whats up, Whats up, Whats up, Whats up, Whats up"
        let colorHeartButton:UIColor = .red
        let imageHeardButton:UIImage = UIImage(systemName:"heart.fill")!

        cell.customizationCell(newsImage: newsImage!, newsDate: newsDate, newsHeadline: newsHeadline, newsText: newsText, colorHeartButton: colorHeartButton, imageHeardButton: imageHeardButton, tagHeartButton: indexPath.item)

        return cell
    }

    func  collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewsCollectionViewCell
        performSegue(withIdentifier: "showDetailNewsFromSelectedNews", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailNewsViewController = segue.destination as? DetailNewsViewController, segue.identifier == "showDetailNewsFromSelectedNews" {
            detailNewsViewController.newsImage = newsImage
            detailNewsViewController.newsDate = newsDate
            detailNewsViewController.newsHeadline = newsHeadline
            detailNewsViewController.newsText = newsText
            detailNewsViewController.news = self.newsSelected
            detailNewsViewController.newsIndexInArray = self.newsSelected[indexPath!.item].newsIndexInArray!
            detailNewsViewController.delegate = self
        }
    }
}

extension SelectedNewsViewController: SendSelectedArrayAndDictionaryDelegate {
    func sendInfoAboutTheHeart(newsIndexInArray: Int) {
        self.newsIndexInArray = newsIndexInArray
    }
    func sendSelectedArray(array:[News]) {
        self.newsSelected = array
    }
}
