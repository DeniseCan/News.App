//
//  ProfileViewController.swift
//  MyFirstProject
//
//  Created by Alexandr on 21.02.2023.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imagePerson: UIImageView!
    @IBOutlet weak var namePerson: UITextField!
    @IBOutlet weak var emailPerson: UITextField!
    
    var imageString:String = ""
    var email:String = ""
    var name:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Выполняем загрузку данных пользователя из Core Data
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                if user.id == 1 {
                    imageString = user.image!
                    name = user.name!
                    email = user.email!
                }
            }
        } catch {
            print("Failed user: \(error)")
        }
        imagePerson.image = UIImage(named:imageString)
        namePerson.text = name
        emailPerson.text = email
    }
    
    @IBAction func outProfile(_ sender: UIButton) {
        let alert = UIAlertController(title: "Выход", message: "Вы уверены, что хотите выйти из аккаунта?", preferredStyle: .alert)
        let alertActionCancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        let alertActionExit = UIAlertAction(title: "Выход", style: .destructive, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(alertActionCancel)
        alert.addAction(alertActionExit)
        present(alert, animated: true, completion: nil)
    }
}
