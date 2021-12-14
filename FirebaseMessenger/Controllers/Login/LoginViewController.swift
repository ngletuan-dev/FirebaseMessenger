//
//  LoginViewController.swift
//  FirebaseMessenger
//
//  Created by Tuấn Nguyễn on 13/12/2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let imageView: UIImageView =  {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Login"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        // Add subviews
        view.addSubview(imageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.frame.size.width/3
        imageView.frame = CGRect(x: (view.frame.size.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
    }
    
    @objc private func didTapRegister() {
        let vcRegister = RegisterViewController()
        vcRegister.title = "Create Account"
        navigationController?.pushViewController(vcRegister, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
