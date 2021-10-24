//
//  makeSurePlaceViewController.swift
//  DoLEMON
//
//  Created by system on 2021/09/23.
//

import UIKit
import MapKit

class ContentViewController: UIViewController {
    
    
    let nameLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.9058823529, blue: 0.9137254902, alpha: 1)
       
        //aboutButton
        let button = UIButton()
        button.frame = CGRect(x:317, y:300,
                               width:63, height:70)
        //button.backgroundColor = UIColor.init(red:0.9, green: 0.9, blue: 0.9, alpha: 1)
        button.setImage(UIImage(named: "addButton"), for: .normal)
                
        self.view.addSubview(button)
        
        //aboutLabel
        nameLabel.frame = CGRect(x: 53, y: 40, width: 308, height: 39)
        nameLabel.font = .boldSystemFont(ofSize: 30)
        //nameLabel.text = self.view.addSubview(nameLabel)
        
//        let addressNameLabel = UILabel()
//        addressNameLabel.frame = CGRect(x: 53, y: 100, width: 308, height: 39)
//        addressNameLabel.text = "dlksnn"
//        self.view.addSubview(addressNameLabel)
    }
}
