//
//  TabBarController.swift
//  MyFirstProject
//
//  Created by Alexandr on 19.02.2023.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
