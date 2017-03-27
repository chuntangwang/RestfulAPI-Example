//
//  Services.swift
//  RestfulAPI-Example
//
//  Created by Chun-Tang Wang on 28/03/2017.
//  Copyright © 2017 Chun-Tang Wang. All rights reserved.
//

import Alamofire
import KeychainAccess

enum Service {
    case login
    case getMember
    case createMember
    
    func url() -> String {
        switch self {
        case .login:
            return "http://52.197.192.141:3443/"
        case .getMember, .createMember:
            return "http://52.197.192.141:3443/member"
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .login, .createMember:
            return .post
        case .getMember:
            return .get
        }
    }
}

struct TokenManager {
    
    static let keychain = Keychain(service: "com.chuntangwang.RestfulAPI-Example")
    
    let token: String
    let expired: Date
    
    init(token: String, expired: Date) {
        self.token = token
        self.expired = expired
        TokenManager.keychain["token"] = token
    }
}
