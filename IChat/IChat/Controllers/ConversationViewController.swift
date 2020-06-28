//
//  ViewController.swift
//  IChat
//
//  Created by yasmin mohsen on 6/25/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationViewController: UIViewController {

    private let spinner=JGProgressHUD(style: .dark)
    
    private let tableView:UITableView = {
        
        let table = UITableView()
        table.isHidden=true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private let label :UILabel={
         let label = UILabel()
        label.textAlignment = .center
        label.text="No Conversation"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.isHidden=true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCompose))
        
        view.addSubview(tableView)
        view.addSubview(label)
        setupTableView()
        fetchUser()
        
        
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
    
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        tableView.frame=view.bounds
        
    }
    
    
    
    private func setupTableView(){
        
        tableView.delegate=self
        tableView.dataSource=self
        
    }
    
    // selectors :
    
    @objc  private func didTapCompose(){
        
        let vc = NewConversationViewController()
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated:true )
        
    }
    
    
    func fetchUser(){
        
        tableView.isHidden=false
        
    }
    
    
    
    
    
}

extension ConversationViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text="Hello world"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title="joe smith"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
}
