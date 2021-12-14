//
//  ViewController.swift
//  FirebaseMessenger
//
//  Created by Tuấn Nguyễn on 13/12/2021.
//

import UIKit

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        
        if !isLoggedIn {
            let vcLogin = LoginViewController()
            let navLogin = UINavigationController(rootViewController: vcLogin)
            navLogin.modalPresentationStyle = .fullScreen
            present(navLogin, animated: false)
        }
    }
    
    
}

