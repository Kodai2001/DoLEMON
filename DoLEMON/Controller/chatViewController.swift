//
//  chatViewController.swift
//  DoLEMON
//
//  Created by system on 2021/09/23.
//

import UIKit

class chatViewController: UIViewController {

    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "hello", time: "9:23 AM"),
        Message(sender: "a@b.com", body: "hora", time:  "8:22 AM"),
        Message(sender: "1@3.com", body: "konnitiwa", time: "4:56 PM")

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.9058823529, blue: 0.9137254902, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func buckButtonPressed(_ sender: UIButton) {
    }
    @IBAction func sendButtonPressed(_ sender: UIButton) {
    }
    
}

extension chatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        return cell
    }
    
    
}
