//
//  LoginViewController.swift
//  RestfulAPI-Example
//
//  Created by Chun-Tang Wang on 25/03/2017.
//  Copyright © 2017 Chun-Tang Wang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.tag = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: UIButton) {
        sender.isEnabled = false
        
        if let vc = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController() {
            
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: {
                sender.isEnabled = true
            })
        }
    }

}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true
        }
        
        return false
    }
}


// MARK: - Keyboard Notification
extension LoginViewController {
    
    func keyboardDidShow(notification: Notification) {
        // Reset first
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = 0
        })
        
        // Shift
        let keyboardRect = (notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        
        if loginButton.frame.maxY > keyboardRect.minY {
            let offset = fabs(keyboardRect.minY - loginButton.frame.maxY)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame.origin.y -= offset
            })
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        // Reset
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = 0
        })
    }
}
