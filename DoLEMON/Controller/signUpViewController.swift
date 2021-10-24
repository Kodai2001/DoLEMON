    //
    //  signUpViewController.swift
    //  DoLEMON
    //
    //  Created by system on 2021/09/23.
    //
    
    import UIKit
    import Firebase
    import FirebaseAuth
    
    class signUpViewController: UIViewController {
        
       
        
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var nameTextField: UITextField!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                    self.view.addGestureRecognizer(tapGesture)
        }
        
        @objc func dismissKeyboard() {
                self.view.endEditing(true)
            }
        
        @IBAction func signUpButton(_ sender: UIButton) {
            
            if let email = emailTextField.text,
               let password = passwordTextField.text,
               nameTextField.text != nil
            {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        print(e)
                    } else {
                        self.performSegue(withIdentifier: "toMainVC", sender: self)
                    }
                }
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let mainVC = segue.destination as? mainViewController
            mainVC?.nameHolder = nameTextField.text!
        }
    }
