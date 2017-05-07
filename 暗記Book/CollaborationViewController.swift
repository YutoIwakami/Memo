//
//  ViewController.swift
//  暗記Book
//
//  Created by T80 on 2016/04/01.
//
//

import UIKit
import FirebaseDatabase

class CollaborationViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate{
    
    @IBOutlet var textField:UITextField!
    @IBOutlet var textView:UITextView!
    
    var id:String!
    var passWord:String!
    var mode:String!
    
    var databaseRef = FIRDatabase.database().reference()
    
    let notificationCenter = NotificationCenter.default
    
    var txtActiveField: UITextField! //編集後のtextFieldを新しく格納する変数を定
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        id = appDelegate.id
        passWord = appDelegate.passWord
        
        self.textField.text = self.id
        textView.text = "Hello"
        
        textView.delegate = self
        textField.delegate = self
        
        if mode == "find"{
            let ref = FIRDatabase.database().reference().child("Memo").child(id).child(passWord)
            ref.observe(.value, with: { (snapshot) in
                let value = snapshot.value as! [String:String]
                if let message = value[self.id] {
                    self.textView.text = "\(message)"
                }
            })
        } else if mode == "new"{
            let ref = FIRDatabase.database().reference().child("Memo").child(id).child(passWord)
            let saveData = [id: textView.text!]
            ref.setValue(saveData)
        }
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewController.closeKeyBoard))
        toolBar.items = [spacer,closeButton]
        toolBar.backgroundColor = UIColor.white
        textView.inputAccessoryView = toolBar
        textField.inputAccessoryView = toolBar
        
        //keyboard Notification(move text view)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.toKey = nil
        //keyboard Notification(move text view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func closeKeyBoard(){
        self.view.endEditing(true)
    }
    
    /* Firebase 書き込み */
    func textFieldDidChange(_ textView: UITextField) {
        let ref = FIRDatabase.database().reference().child("Memo").child(id).child(passWord)
        let saveData = [id: textView.text!]
        ref.setValue(saveData)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let ref = FIRDatabase.database().reference().child("Memo").child(id).child(passWord)
        let saveData = [id: textView.text!]
        ref.setValue(saveData)
        
        ref.observe(.value, with: { (snapshot) in
            let value = snapshot.value as! [String:String]
            if let message = value[self.id] {
                self.textView.text = "\(message)"
            }
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

