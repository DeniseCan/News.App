//
//  RegistrationViewController.swift
//  MyFirstProject
//
//  Created by Alexandr on 19.02.2023.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let storage = UserDefaults.standard
    var profile = Profile.shared
    var news:[News] = []
    
    override func viewDidLoad() {
        //Загружаем данные из сети
        getNewsFromNewsAPI { news in
            self.news = news
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.navigationBar.backIndicatorImage = UIImage()
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        emailTextField.delegate = self
    }
    
    @IBAction func registrationButton(_ sender: UIButton) {
        
        guard let name = nameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        //После сброса пароля, проходим регистрацию заново и удаляем профиль с Core Data
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            if let results = try? context.fetch(fetchRequest) {
                for object in results { context.delete(object) }
            }
        CoreDataManager.shared.saveContext()
        //Выводим alert в зависимости от результата функции isValidEmail
        let isValid = emailTextField.isValidEmail(text: email)
        
        if email.count > 0 && email.contains(" ") == true || password.count > 0 && password.contains(" ") == true || email.count == 0 || password.count == 0 || name.count == 0 {
            let alert = UIAlertController(title: "Ошибка", message: "Заполните пустые поля логина, почты и пароля", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        } else if !isValid {
            let alert = UIAlertController(title: "Ошибка", message: "Проверьте корректность ввода почты", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: { return } )
        } else {
            //При успехе, создаем профиль пользователя
            let profile = Profile.shared
            profile.id = 1
            profile.name = name
            profile.email = email
            profile.imageProfile = "ImageUser"
            //а также создаем сущность User'а в Core Data
            let user = User(context: CoreDataManager.shared.context)
            user.email = profile.email
            user.id = Int16(profile.id)
            user.image = profile.imageProfile
            user.name = profile.name
            user.password = password
            CoreDataManager.shared.context.insert(user)
            CoreDataManager.shared.saveContext()
            
            performSegue(withIdentifier: "showTabBarFromTheRegistration", sender: nil)
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
}
