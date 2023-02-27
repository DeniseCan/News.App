//
//  PasswordResetViewController.swift
//  MyFirstProject
//
//  Created by Alexandr on 19.02.2023.
//

import UIKit
import CoreData

class PasswordResetViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    var emailStorage:String = ""
    var user:User?
    var profile = Profile.shared
    let context = CoreDataManager.shared.context
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //Выполняем загрузку данных пользователя из базы данных
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                if user.id == 1 {
                    emailStorage = user.email!
                }
            }
        } catch {
            print("Failed user: \(error)")
        }
    }
    
    @IBAction func passwordReset(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        
        if email.count > 0 && email.contains(" ") == true || email.count == 0 {
            let alert = UIAlertController(title: "Ошибка", message: "Заполните пустые поля", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
        
        let isValid = emailTextField.isValidEmail(text: email)
        // Выводим alert в зависимости от результата функции isValidEmail
        if !isValid {
            let alert = UIAlertController(title: "Ошибка", message: "Проверьте корректность ввода почты", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: { return } )
        }
        
        if email == emailStorage {
            let request: NSFetchRequest<User> = User.fetchRequest()
            if let users = try? context.fetch(request) {
                for user in users {
                    if user.id == 1 {
                        user.password = nil
                        try? context.save()
                    }
                }
            }
            let alert = UIAlertController(title: "Успешно", message: "Инструкция по сбросу пароля придет Вам на почту", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.navigationController?.popToRootViewController(animated: true)
            })
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
