//
//  chatListViewController.swift
//  DoLEMON
//
//  Created by system on 2021/09/23.
//

import UIKit

class chatListViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [Message] = [
        Message(sender: "Kodai", body: "hello", time: "9:23 AM"),
        Message(sender: "Sakura", body: "焼いてんねんっ//", time: "4:54 PM"),
        Message(sender: "Take", body: "konnitiwa", time: "1:38 PM")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "chatListCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
    }
    

}

extension chatListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! chatListCell
        cell.userNameLabel.text = messages[indexPath.row].sender
        cell.messageLabel.text = messages[indexPath.row].body
        cell.timeLabel.text = messages[indexPath.row].time
        
        return cell
    }
    
    
}

extension chatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(indexPath.row)
        performSegue(withIdentifier: "toChatView", sender: self)
        
    }
    
}
