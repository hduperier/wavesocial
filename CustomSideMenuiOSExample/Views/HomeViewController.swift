//
//  ViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/§/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    @IBOutlet var sideMenuBtn: UIBarButtonItem!

    // Adding Scrollview to view Controller
    private let scrollView: UIScrollView =  {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    // Adding "The Wave" text label
    private let waveText: UILabel = {
        let waveText = UILabel()
        waveText.text = "The Wave"
        waveText.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        waveText.font = waveText.font.withSize(20.0)
        return waveText
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Menu Button Tint Color
        navigationController?.navigationBar.tintColor = .white

        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        //Change title
        title = "My Night Out"
        //Change Background colors of nav bar and view
        view.backgroundColor = .black
        navigationController?.navigationBar.barTintColor = .black
        
        // Adding scrollView to View
        view.addSubview(scrollView)
        
        //Add elements to scrollView
        scrollView.addSubview(waveText)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //setting bounds on scrollview within view Controller
        scrollView.frame = view.bounds
        
        //Customize all element frames
        waveText.frame = CGRect(x: 20, y: 10, width: scrollView.width/5, height: 27)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       validateAuth()
    }

    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
}
