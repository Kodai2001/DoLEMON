//
//  searchFrinedViewController.swift
//  DoLEMON
//
//  Created by system on 2021/09/23.
//

import UIKit

class searchFrinedViewController: UIViewController {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()  
    }
    
    override func viewWillAppear(_ animated: Bool) {
            navigationController?.navigationBar.isHidden = false
        }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if userNameTextField.text != "" {
            performSegue(withIdentifier: "toAddFriendView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addFriendVC = segue.destination as! addFriendViewController
        print(userNameTextField.text!)
        addFriendVC.userName = self.userNameTextField.text!
    }
    
    
  
    

}
