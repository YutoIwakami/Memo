//
//  ViewController.swift
//  暗記Book
//
//  Created by T80 on 2016/04/01.
//
//

import UIKit

class ViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate{
    
    @IBOutlet var textField:UITextField!
    @IBOutlet var textView:UITextView!
    @IBOutlet var time:UILabel!
    
    var saveText: [AnyObject] = []
    let userDefault = UserDefaults(suiteName: "group.MemoBook")

    var alertTitle:String!
    var alertText:String!
    
    let date = Date()
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        textView.delegate = self
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = " "
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let key = appDelegate.toKey else { return }
        let data = userDefault?.object(forKey: key) as! [String : String]
        print(data)
        textView.text = data["text"]
        textField.text = data["title"]
        time.text = data["time"]
        
        self.startObserveKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.toKey = nil
        
        self.stopOberveKeyboardNotification()
    }
    
    func closeKeyBoard(){
        self.view.endEditing(true)
    }
    
    @IBAction func save(){
        self.view.endEditing(true)
        if textField.text == ""{
            alertTitle = "Error"
            alertText = NSLocalizedString("TitleError", comment: "")
            let alert = UIAlertController(title: alertTitle, message: alertText, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            dateFormatter.dateFormat = "yyyy/MM/dd h:mm:ss a"
            time.text = dateFormatter.string(from: date as Date)
            
            let key: String = UUID().uuidString
            print(key)
            
            let appDelegate:AppDelegate =
                UIApplication.shared.delegate as! AppDelegate
            
            let textData = ["text":textView.text,"title":textField.text,"time":time.text]
            if appDelegate.toKey == nil{
                
                userDefault?.set(textData, forKey: key)
                
                if let keys = userDefault?.value(forKey: "keys") as? [String] {
                    var keysArray = keys
                    keysArray.append(key)
                    userDefault?.set(keysArray, forKey: "keys")
                } else {
                    let keysArray = [key]
                    userDefault?.set(keysArray, forKey: "keys")
                }
            }else{
                userDefault?.set(textData, forKey: appDelegate.toKey!)
            }
            userDefault?.synchronize()
            
            let saveText = NSLocalizedString("Save", comment: "")
            let alert = UIAlertController(title: nil, message: saveText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func showColorPicker(){
        performSegue(withIdentifier: "toInfo", sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

/** キーボード追従に関連する処理をまとめたextenstion */
extension ViewController{
    /** キーボードのNotificationを購読開始 */
    func startObserveKeyboardNotification(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector:#selector(ViewController.willShowKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector:"willHideKeyboard:", name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    /** キーボードのNotificationの購読停止 */
    func stopOberveKeyboardNotification(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /** キーボードが開いたときに呼び出されるメソッド */
    func willShowKeyboard(_ notification:Notification){
        NSLog("willShowKeyboard called.")
        let duration = notification.duration()
        let rect     = notification.rect()
        if let duration=duration,let rect=rect {
            // ここで「self.bottomLayoutGuide.length」を使っている理由：
            // tabBarの表示/非表示に応じて制約の高さを変えないと、
            // viewとキーボードの間にtabBar分の隙間が空いてしまうため、
            // ここでtabBar分の高さを計算に含めています。
            // - tabBarが表示されていない場合、self.bottomLayoutGuideは0となる
            // - tabBarが表示されている場合、self.bottomLayoutGuideにはtabBarの高さが入る
            
            // layoutIfNeeded()→制約を更新→UIView.animationWithDuration()の中でlayoutIfNeeded() の流れは
            // 以下を参考にしました。
            // http://qiita.com/caesar_cat/items/051cda589afe45255d96
            self.view.layoutIfNeeded()
            self.bottomConstraint.constant=rect.size.height - self.bottomLayoutGuide.length;
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.view.layoutIfNeeded()  // ここ、updateConstraint()でも良いのかと思ったけど動かなかった。
            })
        }
    }
    /** キーボードが閉じたときに呼び出されるメソッド */
    func willHideKeyboard(_ notification:Notification){
        NSLog("willHideKeyboard called.")
        let duration = notification.duration()
        if let duration=duration {
            self.view.layoutIfNeeded()
            self.bottomConstraint.constant=0
            UIView.animate(withDuration: duration,animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
}

/** キーボード表示通知の便利拡張 */
extension Notification{
    /** 通知から「キーボードの開く時間」を取得 */
    func duration()->TimeInterval?{
        let duration:TimeInterval? = self.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        return duration;
    }
    /** 通知から「表示されるキーボードの表示位置」を取得 */
    func rect()->CGRect?{
        let rowRect:NSValue? = self.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let rect:CGRect? = rowRect?.cgRectValue
        return rect
    }
    
}


