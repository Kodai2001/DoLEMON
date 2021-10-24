//
//  loginViewController.swift
//  DoLEMON
//
//  Created by system on 2021/10/02.
//

import UIKit
import FirebaseAuth

class loginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                self.view.addGestureRecognizer(tapGesture)
        
        loginButton.layer.cornerRadius = 30.0
        addShadow(button: loginButton)
    }
    
    @objc func dismissKeyboard() {
            self.view.endEditing(true)
        }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text,
           let password = passwordTextField.text,
           nameTextField.text != nil
        {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "toMainVC", sender: self)
                }
                
            }
        }
    }
    
    func addShadow(button: UIButton) {
        // 影の濃さ
        button.layer.shadowOpacity = 0.3
        // 影のぼかしの大きさ
        button.layer.shadowRadius = 10
        // 影の色
        button.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segueのIDを確認して特定のsegueのときのみ動作させる
                if segue.identifier == "toMainVC" {
                    // 2. 遷移先のViewControllerを取得
                    let mainVC = segue.destination as? mainViewController
                    // 3. １で用意した遷移先の変数に値を渡す
                    mainVC?.nameHolder = nameTextField.text!
                }
    }
}
