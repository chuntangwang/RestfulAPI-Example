//
//  MemberViewController.swift
//  RestfulAPI-Example
//
//  Created by Chun-Tang Wang on 27/03/2017.
//  Copyright © 2017 Chun-Tang Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

class MemberViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var members = [Member]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestMembers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismissWithBackAnimation()
    }
    
    // MARK: - Data Request
    func requestMembers() {
        
        guard let token = TokenManager.keychain["token"] else {
            showAlert(title:"Warning", message: "Wrong session token")
            return
        }
        
        let api: Service = .getMember
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        
        Alamofire.request(api.url(),
                          method: api.method(),
                          encoding: JSONEncoding.default,
                          headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    self.members = Members(json: json["data"]).members
                    self.tableView.reloadData()
                case .failure(let error):
                    self.showAlert(title:"Error", message: error.localizedDescription)
                }
        }
    }
}

// MARK: - TableView Delegate
extension MemberViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = members[indexPath.row].name
        return cell
    }
}
