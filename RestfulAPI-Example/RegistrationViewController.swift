//
//  RegistrationViewController.swift
//  RestfulAPI-Example
//
//  Created by Chun-Tang Wang on 27/03/2017.
//  Copyright © 2017 Chun-Tang Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

class RegistrationViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    
    let keychain = Keychain(service: "com.chuntangwang.RestfulAPI-Example")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameTextField.delegate = self
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
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismissWithBackAnimation()
    }
    
    
    @IBAction func apply(_ sender: UIButton) {
        guard let token = keychain["token"] else {
            showAlert(title:"Warning", message: "Wrong session token")
            return
        }
        
        guard
            let username = usernameTextField.text,
            !username.isEmpty else {
                showAlert(title:"Warning", message: "Please input username.")
                return
        }
        
        sender.isEnabled = false
        
        let api: Service = .createMember
        let parameters: Parameters = [
            "name": username
        ]
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        
        Alamofire.request(api.url(),
                          method: api.method(),
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let result = json["code"].stringValue
                    self.showAlert(title:"Result", message: result)
                case .failure(let error):
                    self.showAlert(title:"Error", message: error.localizedDescription)
                }
                
                sender.isEnabled = true
        }
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Keyboard Notification
extension RegistrationViewController {
    
    func keyboardDidShow(notification: Notification) {
        // Reset first
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = 0
        })
        
        // Shift
        let keyboardRect = (notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        
        if applyButton.frame.maxY > keyboardRect.minY {
            let offset = fabs(keyboardRect.minY - applyButton.frame.maxY)
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
