//
//  PassWordCell.swift
//  Memo
//
//  Created by 電子技術研究部芝浦工業大学附属中学高等学校 on 2017/04/24.
//
//

import UIKit

class PassWordCell: UITableViewCell,UITextFieldDelegate{
    
    @IBOutlet var label:UILabel!
    
    @IBOutlet var textField:UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.closeKeyBoard))
        toolBar.items = [spacer,closeButton]
        textField.inputAccessoryView = toolBar
        
        // Initialization code
        self.label.text = "Password"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func closeKeyBoard(){
        self.textField.endEditing(true)
    }
    
    func textFieldDidChange(){
        print("text",textField.text!)
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.passWord = textField.text!
    }
    
}
