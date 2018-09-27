//
//  LoginViewController.swift
//  Happystagram
//
//  Created by 三上大河 on 2018/09/25.
//  Copyright © 2018年 三上大河. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func createNewUser(_ sender: Any) {
        if emailTextField.text == nil || passwordTextField.text == nil {
            let alertViewController = UIAlertController(title: "おっと。", message: "入力欄が空の状態です", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertViewController.addAction(okAction)
            present(alertViewController, animated: true, completion: nil)
        } else {
            // 新規のユーザー登録
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error == nil {
                    // 成功
                    UserDefaults.standard.set("check", forKey: "check")
                    self.dismiss(animated: true, completion: nil)
                
                } else {
                    // 失敗
                    let alertViewController = UIAlertController(title: "おっと。", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertViewController.addAction(okAction)
                    self.present(alertViewController, animated: true, completion: nil)
                }
            } )
        }
    }
    
    @IBAction func loginUser(_ sender: Any) {
        // ログイン
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error == nil {
                
            } else {
                let alertViewController = UIAlertController(title: "おっと。", message: error?.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertViewController.addAction(okAction)
                self.present(alertViewController, animated: true, completion: nil)
            }
        } )
    }
    
}
