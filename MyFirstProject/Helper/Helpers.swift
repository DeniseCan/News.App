//
//  ValidEmail.swift
//  MyFirstProject
//
//  Created by Alexandr on 22.02.2023.
//

import UIKit

//Для проверки, является ли введенный текст в TextField допустимым email
extension UITextField {
    
    func isValidEmail(text:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: text)
    }
}

//Протокол для телепорта данных между контроллерами
protocol SendSelectedArrayAndDictionaryDelegate {
    func sendSelectedArray(array:[News])
    func sendInfoAboutTheHeart(newsIndexInArray:Int)
}
