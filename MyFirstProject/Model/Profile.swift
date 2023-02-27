//
//  Model.swift
//  MyFirstProject
//
//  Created by Alexandr on 20.02.2023.
//

import UIKit

class Profile {
    
    static let shared = Profile()
    
    var id:Int = 0
    var name:String = ""
    var email:String = ""
    var imageProfile:String = ""
    
    private init() {}
    
}
