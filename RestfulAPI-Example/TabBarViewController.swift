//
//  TabBarViewController.swift
//  RestfulAPI-Example
//
//  Created by Chun-Tang Wang on 26/03/2017.
//  Copyright © 2017 Chun-Tang Wang. All rights reserved.
//

import UIKit

enum Menu {
    case members
    case registration
    case logout
    
    func description() -> String {
        switch self {
        case .members:
            return "Show Members"
        case .registration:
            return "Create Member"
        case .logout:
            return "Logout"
        }
    }
}

class TabBarViewController: UITabBarController {
    
    let menuItems: [Menu] = [.members, .registration, .logout]
    
    lazy var overlayView: UIView = {
        let view: UIView = UIView(frame: self.view.frame)
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    lazy var slideMenu: SlideMenuView = {
        let view = UINib(nibName: "SlideMenuView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SlideMenuView
        view.backgroundColor = .clear
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideSlideMenu))
        tap.delegate = self
        return tap
    }()
    
    lazy var swipeGestureRecognizer: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(hideSlideMenu))
        swipe.delegate = self
        swipe.direction = .left
        return swipe
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(displaySlideMenu),
                                               name: Notification.Name.displaySlideMenu, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Gesture
    func initializeGestures() {
        slideMenu.addGestureRecognizer(tapGestureRecognizer)
        slideMenu.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    // MARK: - Slide Menu
    func displaySlideMenu() {
        let width = view.frame.width
        let frame = CGRect(x: -width, y: 0, width: width, height: view.frame.height)
        slideMenu.frame = frame
        
        view.addSubview(overlayView)
        view.addSubview(slideMenu)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.slideMenu.frame = self.view.frame
        })
    }
    
    func hideSlideMenu() {
        let width = view.frame.width
        let frame = CGRect(x: -width, y: 0, width: width, height: view.frame.height)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.slideMenu.frame = frame
        }, completion: { (completed) in
            self.slideMenu.removeFromSuperview()
            self.overlayView.removeFromSuperview()
        })
    }
}

// MARK: - TableView Delegate
extension TabBarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SlideMenuCell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = menuItems[indexPath.row].description()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var presetVc: UIViewController? = nil
        let storyboard = UIStoryboard(name: "SlideMenu", bundle: nil)
        
        switch menuItems[indexPath.row] {
        case .members:
            presetVc = storyboard.instantiateViewController(withIdentifier: "MemberViewController")
        case .registration:
            presetVc = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController")
        case .logout:
            dismiss(animated: true, completion: nil)
        }
        
        if let vc = presetVc {
            presentWithPushAnimation(viewControllerToPresent: vc, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Gesture Delegate
extension TabBarViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if gestureRecognizer.view == touch.view {
            return true
        } else if gestureRecognizer == swipeGestureRecognizer {
            return true
        }
        
        return false
    }
}
