//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    var translated: String = ""
    var notTranslated: String = ""
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    
    @IBOutlet weak var button: UIButton!
    
    var textField : UITextField!
    
    @IBOutlet weak var toBeTranslated: UILabel!
    @IBOutlet weak var textTranslated: UILabel!
    
    @IBOutlet weak var languagePickerView: UIPickerView!
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    var languageArray = [[" ", "English"], ["Afrikaans", "Hebrew", "Irish", "Icelandic", "French"]]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return languageArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageArray[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageArray[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(component)
        print(row)
        
        switch (component) {
        case 0:
            notTranslated = languageArray[component][row]
            toBeTranslated.text = notTranslated
            
        case 1:
            translated = languageArray[component][row]
            textTranslated.text = translated

        default:
            break
        }
    }
    
    
    
    
   // func numberOfComponents(in pickerView: UIPickerView) -> Int {
    //    return languageArray.count
   // }
    
   // func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
   // }
    
   // func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

   // }
    
   // func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
   // }
    
  //  func textFieldDidBeginEditing(_ textField: UITextField) {
    //    if (textField == self.textbox1){
    //        self.toTranslatePicker.isHidden = //false
    
      //  }
      //  else if (textField == self.textbox2){
          //  self.slectedLanguagePicker.isHidden = false
            
      //  }
        
   // }
    
   // func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //    textField.resignFirstResponder()
    //    self.textbox1.resignFirstResponder()
    //    return true
   // }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "Text to Translate")
        {
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "")
        {
            textView.text = "Text to Translate"
        }
        textView.resignFirstResponder()
    }
    
    
    func doneButtonAction(){
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    
    //var data = NSMutableData()
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red:0.45, green:0.88, blue:0.48, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //toTranslatePicker.selectRow(row, inComponent: 1, animated: true)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
        
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ViewController.doneButtonAction))
        
        //array of BarButtonItems
        var arr = [UIBarButtonItem]()
        arr.append(flexSpace)
        arr.append(doneBtn)
        toolbar.setItems(arr, animated: false)
        toolbar.sizeToFit()
        
        //setting toolbar as inputAccessoryView
      //  self.textbox1.inputAccessoryView = toolbar
      //  self.textbox2.inputAccessoryView = toolbar
        self.textToTranslate.inputAccessoryView = toolbar
        
        button.layer.cornerRadius = 4
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func translate(_ sender: AnyObject) {
        
        let str = textToTranslate.text
        let escapedStr = str?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        var translateTo = ""
        switch languagePickerView.selectedRow(inComponent: 1) {
        case 0:
            translateTo = "af"
        case 1:
            translateTo = "he"
        case 2:
            translateTo = "ga"
        case 3:
            translateTo = "is"
        case 4:
            translateTo = "fr"
        default:
            translateTo = "en"
        }
        
        let langStr = ("en|"+translateTo).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let urlStr:String = ("https://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        
        let url = URL(string: urlStr)
        
        let request = URLRequest(url: url!)// Creating Http Request
        
        activityIndicator.startAnimating()
        
        var result = "<Translation Error>"
        
        let task = defaultSession.dataTask(with: request){
            (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    
                    let jsonDict: NSDictionary!=(try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    
                    if(jsonDict.value(forKey: "responseStatus") as! NSNumber == 200){
                        let responseData: NSDictionary = jsonDict.object(forKey: "responseData") as! NSDictionary
                        
                        result = responseData.object(forKey: "translatedText") as! String
                    }
                }
                
                DispatchQueue.main.sync()
                    {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.translatedText.text = result
                }
            }
        }
        task.resume()
    }
}
