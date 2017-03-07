//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    
    var textField : UITextField!
    
    @IBOutlet weak var textbox1: UITextField!
    @IBOutlet weak var textbox2: UITextField!
    
    @IBOutlet weak var toTranslatePicker: UIPickerView!
    @IBOutlet weak var slectedLanguagePicker: UIPickerView!
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    var languages = ["Afrikaans", "Hebrew", "Irish", "Icelandic"]
    var translateFrom = [" ", "English"]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countrows : Int = translateFrom.count
        if pickerView == slectedLanguagePicker {
            
            countrows = self.languages.count
        }
        
        return countrows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == toTranslatePicker {
            
            let titleRow = translateFrom[row]
            
            return titleRow
            
        }
            
        else if pickerView == slectedLanguagePicker{
            let titleRow = languages[row]
            
            return titleRow
        }
        
        return ""
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == toTranslatePicker {
            self.textbox1.text = self.translateFrom[row]
            self.toTranslatePicker.isHidden = true
        }
            
        else if pickerView == slectedLanguagePicker{
            self.textbox2.text = self.languages[row]
            self.slectedLanguagePicker.isHidden = true
            
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.textbox1){
            self.toTranslatePicker.isHidden = false
            
        }
        else if (textField == self.textbox2){
            self.slectedLanguagePicker.isHidden = false
            
        }
        
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func translate(_ sender: AnyObject) {
        
        let str = textToTranslate.text
        let escapedStr = str?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        var translateTo = ""
        switch slectedLanguagePicker.selectedRow(inComponent: 0) {
        case 0:
            translateTo = "af"
        case 1:
            translateTo = "he"
        case 2:
            translateTo = "ga"
        case 3:
            translateTo = "is"
        default:
            translateTo = "en"
        }
        
        let langStr = ("en|"+translateTo).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        let urlStr:String = ("https://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        
        
        let url = URL(string: urlStr)
        
        
        let request = URLRequest(url: url!)// Creating Http Request
        
        
        //var data = NSMutableData()var data = NSMutableData()
        
        
        //let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        //indicator.color = UIColor.red
        //indicator.center = view.center
        //view.addSubview(indicator)
        //indicator.startAnimating()
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
                        //indicator.stopAnimating()
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.translatedText.text = result
                }
            }
        }
        task.resume()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
