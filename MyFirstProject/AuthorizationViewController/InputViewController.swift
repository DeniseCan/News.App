//
//  ViewController.swift
//  MyFirstProject
//
//  Created by Alexandr on 18.02.2023.
//

import UIKit
import CoreData

class InputViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var emailStorage:String = ""
    var passwordStorage:String?
    var news:[News] = []
    
    override func viewDidLoad() {
        //Выполняем загрузку данных пользователя из базы данных
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                if user.id == 1 {
                    emailStorage = user.email!
                    guard let password = user.password else { return }
                    passwordStorage = password
                }
            }
        } catch {
            print("Failed user: \(error)")
        }
        //Загружаем данные из сети
        getNewsFromNewsAPI { news in
            self.news = news
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        emailTextField.delegate = self
    }
    
    @IBAction func InputButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        // Выводим alert в зависимости от результата функции isValidEmail
        let isValid = emailTextField.isValidEmail(text: email)
        
        if email.count > 0 && email.contains(" ") == true || password.count > 0 && password.contains(" ") == true ||
            email.count == 0 || password.count == 0 {
            let alert = UIAlertController(title: "Ошибка", message: "Заполните пустые поля", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }  else if !isValid {
            let alert = UIAlertController(title: "Ошибка", message: "Проверьте корректность ввода почты", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: { return } )
        } else if email != emailStorage || password != passwordStorage {
            let alert = UIAlertController(title: "Ошибка", message: "Указана неверная почта или пароль", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        } else if emailTextField.text == emailStorage && passwordTextField.text == passwordStorage {
            performSegue(withIdentifier: "showTabBarFromTheInput", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Получаем ссылку на NewsViewController для инициализации свойства news
        if let tabBarController = segue.destination as? TabBarController {
            if let navController = tabBarController.viewControllers![0] as? NavigationViewController {
                if let newsViewcontroller = navController.topViewController as? NewsViewController {
                    newsViewcontroller.news = self.news
                }
            }
        }
    }
    
    @IBAction func unwindToInputViewController(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
    }
}
