//
//  ViewController.swift
//  DoLEMON
//
//  Created by system on 2021/09/22.
//

import UIKit
import FirebaseAuth

class homeViewController: UIViewController {
    
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 30.0
        loginButton.layer.cornerRadius = 30.0
        addShadow(button: signUpButton)
        addShadow(button: loginButton)
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
}
