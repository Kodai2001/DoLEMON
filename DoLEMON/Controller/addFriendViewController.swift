//
//  addFriendViewController.swift
//  DoLEMON
//
//  Created by system on 2021/09/23.
//

import UIKit

class addFriendViewController: UIViewController {
    
    var userName: String?
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userNameLabel.text = userName
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
    
 

}
