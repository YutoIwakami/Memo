//
//  TableViewController.swift
//  暗記Book
//
//  Created by T80 on 2016/04/01.
//
//

import UIKit

class TableViewController: UITableViewController ,UIAlertViewDelegate,UIViewControllerTransitioningDelegate{
    
    let userDefault = UserDefaults(suiteName: "group.MemoBook")
    let recoveryUserDefault = UserDefaults.standard
    var keys:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(TableViewController.trash))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButton))
        let collaborateButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(self.collaborate))
        
//        let collaborateButton = UIBarButtonItem(image: <#T##UIImage?#>, landscapeImagePhone: <#T##UIImage?#>, style: <#T##UIBarButtonItemStyle#>, target: <#T##Any?#>, action: <#T##Selector?#>)
        self.navigationItem.leftBarButtonItems = [editButtonItem,trashButton]
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.toKey = nil
        tableView.register(UINib(nibName: "TableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        self.clearsSelectionOnViewWillAppear = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let keys = userDefault?.value(forKey: "keys") as? [String] {
            self.keys = keys
        }
        
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
        
    }
    
    //tableview
    override func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        //remove Data
        keys?.remove(at: indexPath.row)
        userDefault?.set(keys, forKey: "keys")
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if there is data
        if let keys = self.keys, self.keys!.count > 0 {
            return keys.count
        //if there isn't data
        } else {
            
            let alertText = NSLocalizedString("Alert_Title", comment: "")
            let alertMessageY = NSLocalizedString("Alert_Message_Y", comment: "")
            let alertMessageN = NSLocalizedString("Alert_Message_N", comment: "")
            
            let alert = UIAlertController(title: nil, message: alertText, preferredStyle: .alert)
            
            let cancelAction:UIAlertAction = UIAlertAction(title: alertMessageN,
                                                           style: .cancel,
                                                           handler:{
                                                            (action:UIAlertAction!) -> Void in
            })
            
            let okButton:UIAlertAction = UIAlertAction(title: alertMessageY,
                                                       style: .default,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
                                                        self.addButton()
            })
            alert.addAction(cancelAction)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
            return 0
        }
    }
    
    //puts data in to custom cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        guard let keys = self.keys else { return UITableViewCell() }
        let key = keys[indexPath.row]
        guard let dictionary:[String:String] = userDefault?.object(forKey: key) as? [String:String] else { return UITableViewCell() }
        
        let title = dictionary["title"]
        let text = dictionary["text"]
        let time = dictionary["time"]
        
        tableViewCell.cell.text = title
        tableViewCell.subtitle.text = text
        tableViewCell.timeLabel.text = time
        
        return tableViewCell
    }
    
    override func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.toKey = keys![(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    func addButton(){
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    func trash(){
        
        let alertMessage = NSLocalizedString("Delete_Message", comment: "")
        let alertY = NSLocalizedString("Alert_Message_Y", comment: "")
        let alertN = NSLocalizedString("Alert_Message_N", comment: "")
        
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: alertN, style: .default, handler:{
            (action:UIAlertAction!) -> Void in
        })
        
        let okButton:UIAlertAction = UIAlertAction(title: alertY, style: .destructive, handler:{
            (action:UIAlertAction!) -> Void in
            self.keys?.removeAll()
            self.userDefault?.set(self.keys, forKey: "keys")
            self.tableView?.reloadData()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func collaborate(){
//        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
//        
//        let cancelAction:UIAlertAction = UIAlertAction(title: "Make Room", style: .cancel, handler:{
//            (action:UIAlertAction!) -> Void in
//            
//        })
//        
//        let okButton:UIAlertAction = UIAlertAction(title: "Search Room", style: .default, handler:{
//            (action:UIAlertAction!) -> Void in
//        })
//        
//        alert.addAction(cancelAction)
//        alert.addAction(okButton)
//        present(alert, animated: true, completion: nil)
        performSegue(withIdentifier: "collaborate", sender: nil)
    }
    
}
