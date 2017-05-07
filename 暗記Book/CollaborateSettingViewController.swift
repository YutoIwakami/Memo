//
//  CollaborateSettingViewController.swift
//  Memo
//
//  Created by 雄飛  on 2017/04/04.
//
//

import UIKit

class CollaborateSettingViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.register(UINib(nibName: "PassWordCell",bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            tableView.register(UINib(nibName: "IDCell",bundle: nil), forCellReuseIdentifier: "cell")
            let idCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IDCell
            idCell.label.text = "Room Name/ID"
            return idCell
        }else{
            tableView.register(UINib(nibName: "PassWordCell",bundle: nil), forCellReuseIdentifier: "cell")
            let passWordCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PassWordCell
//            tableViewCell.label.text = "Password"
            return passWordCell
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc: CollaborationViewController = (segue.destination as? CollaborationViewController)!
        // SubViewController のselectedImgに選択された画像を設定する
        
        
        if (segue.identifier == "new") {
            vc.mode = "new"
        }
        
        if (segue.identifier == "find") {
            vc.mode = "find"
        }
    }
}
