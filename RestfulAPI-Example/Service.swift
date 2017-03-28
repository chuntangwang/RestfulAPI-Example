//
//  Service.swift
//  RestfulAPI-Example
//
//  Created by Chun-Tang Wang on 28/03/2017.
//  Copyright © 2017 Chun-Tang Wang. All rights reserved.
//

import Alamofire

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
