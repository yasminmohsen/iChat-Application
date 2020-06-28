//
//  ViewController.swift
//  IChat
//
//  Created by yasmin mohsen on 6/25/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser?.uid == nil{
            
            let vc=LoginViewController()
                       let nav = UINavigationController(rootViewController: vc)
                       nav.modalPresentationStyle = .fullScreen
                       present(nav,animated: true)
        }
        
        
     
        
        
    }
}

