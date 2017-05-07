//
//  MessagesViewController.swift
//  Memo for iMessage
//
//  Created by 電技研 on 2016/11/07.
//
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var tableView:UITableView!
    
    let userDefault = UserDefaults(suiteName: "group.MemoBook")!
    
    var keys:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MessageTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let keys = userDefault.value(forKey: "keys") as? [String] {
            self.keys = keys
        }
        tableView.reloadData()
    }
    
    /*  ここから記述　*/
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 3
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let keys = self.keys {
            return keys.count
        } else {
            print("error")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTableViewCell
        print(cell)
        guard let keys = self.keys else { return UITableViewCell() }
        let key = keys[indexPath.row]
        print("set",userDefault.value(forKey: key))
        guard let dictionary:[String:String] = userDefault.object(forKey: key) as? [String:String] else { return UITableViewCell() }
        
        cell.cell.text = dictionary["title"]
        cell.subtitle.text = dictionary["text"]
        cell.timeLabel.text = dictionary["time"]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = keys?[indexPath.row]
        let dictionary:[String:String] = userDefault.object(forKey: key!) as! [String:String]
        let title = dictionary["title"]
        //        layout.subcaption = dictionary["text"]
        let text = dictionary["text"]
        
        self.activeConversation?.insertText(title! + "\n" + text!, completionHandler: nil)
    }
    
}
