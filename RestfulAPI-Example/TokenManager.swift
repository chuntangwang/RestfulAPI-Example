//
//  TokenManager.swift
//  RestfulAPI-Example
//
//  Created by Tang Wang on 28/03/2017.
//  Copyright © 2017 Chun-Tang Wang. All rights reserved.
//

import Alamofire
import SwiftyJSON
import KeychainAccess

class TokenManager {
    
    static let keychain = Keychain(service: "com.chuntangwang.RestfulAPI-Example")
    static let shared = TokenManager()
    
    fileprivate var expired: Date = Date()
    fileprivate var timer: Timer?
    fileprivate var username = ""
    fileprivate var password = ""
    
    
    fileprivate init() {}
    
    func steup(token: String, expired: TimeInterval) {
        TokenManager.keychain["token"] = token
        
        let date = Date(timeIntervalSince1970: TimeInterval(expired))
        
        // Make sure token will refresh before 10 mins of expired date
        self.expired = date.addingTimeInterval(600)
        print("Updated expired date: \(self.expired)")
    }
    
    func stopMaintainToken() {
        timer?.invalidate()
        timer = nil
    }
    
    func startMaintainToken() {
        stopMaintainToken()
        
        username = TokenManager.keychain["username"] ?? ""
        password = TokenManager.keychain["password"] ?? ""
        
        DispatchQueue.global(qos: .default).async {
            // Check expired every 10 mins
            self.timer = Timer(timeInterval: 600, target: self, selector: #selector(self.checkExpired(timer:)), userInfo: nil, repeats: true)
            
            if let timer = self.timer {
                let runLoop = RunLoop.current
                runLoop.add(timer, forMode: .defaultRunLoopMode)
                runLoop.run()
            }
        }
    }
    
    @objc fileprivate func checkExpired(timer: Timer) {
        
        let result = Date().compare(expired)
        switch result {
        case .orderedDescending:
            refreshToken()
        default:
            return
        }
    }
    
    func refreshToken() {
        
        let api: Service = .login
        let parameters: Parameters = [
            "name": username,
            "pwd": password
        ]
        
        Alamofire.request(api.url(),
                          method: api.method(),
                          parameters: parameters,
                          encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let token = json["token"]["token"].stringValue
                    let expired = json["token"]["exp"].doubleValue
                    TokenManager.shared.steup(token: token, expired: expired)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
