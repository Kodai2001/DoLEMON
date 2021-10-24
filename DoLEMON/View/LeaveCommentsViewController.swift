//
//  LeaveCommentsViewController.swift
//  DoLEMON
//
//  Created by system on 2021/10/10.
//

import UIKit
import MapKit

class LeaveCommentsViewController: UIViewController {
    
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var freeTextView: UITextView!
    
    var placeName: String!
    var address: String?
    
    var lonSearched: CLLocationDegrees = 0.0
    var latSearched:CLLocationDegrees = 0.0
    var pinTitle: String = ""
    
    var nameHolder: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textView
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    
        
        //遷移先から
        userNameTextField.text = nameHolder
        placeNameLabel.text = placeName
        addressLabel.text = address
        placeNameLabel.numberOfLines = 0
        placeNameLabel.sizeToFit()
        
        //freeText欄のデザイン
        freeTextView.layer.borderColor = #colorLiteral(red: 0.9215686275, green: 0.5725490196, blue: 0.7450980392, alpha: 1)
        freeTextView.layer.borderWidth = 5.0
        freeTextView.layer.cornerRadius = 10.0
        freeTextView.layer.masksToBounds = true
        
        //
        freeTextView.placeholder = " 　　ちょっとしたことを残しておこう😏"
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toMainVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainVC = segue.destination as? mainViewController
        mainVC?.lonSearched = lonSearched
        mainVC?.latSearched = latSearched
        mainVC?.pinTitle = pinTitle
        mainVC?.userName = userNameTextField.text ?? "No name"
        mainVC?.textWrittenByUser = freeTextView.text
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                } else {
                    let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                    self.view.frame.origin.y -= suggestionHeight
                }
            }
        }
    
    @objc func dismissKeyboard() {
            self.view.endEditing(true)
        }
    
    @objc func keyboardWillHide() {
           if self.view.frame.origin.y != 0 {
               self.view.frame.origin.y = 0
           }
       }

    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
}

extension LeaveCommentsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}



extension UITextView :UITextViewDelegate
{
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}

