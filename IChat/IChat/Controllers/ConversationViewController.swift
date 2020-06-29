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


struct Conversation {
    let id : String
    let name : String
    let otherUserEmail:String
    let latestMessage:LatestMessage
}

struct LatestMessage {
    let date :String
    let text:String
    let isRead:Bool
    
}



class ConversationViewController: UIViewController {

    private var conversations=[Conversation]()
    
    private let spinner=JGProgressHUD(style: .dark)
    
    private let tableView:UITableView = {
        
        let table = UITableView()
        table.isHidden=true
        table.register(ConversationsTableViewCell.self, forCellReuseIdentifier: ConversationsTableViewCell.identifier)
        
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
        startListinigForConversation()
        
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
    
    private func startListinigForConversation(){
        
        let userEmail = (Auth.auth().currentUser?.email)!
       let safeEmail = DatabaseManager.safeEmail(email: userEmail)
        DatabaseManager.shared.getAllConversation(for: safeEmail, completion: {result in
            
            switch result {
                
                
                
            case .success(let conversations):
                
                guard !conversations.isEmpty else{
                    return
                }
                self.conversations=conversations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error_):
               print ("error is \(error_)")
            }
            
        })
    }
    
    
    
    
    // selectors :
    
    @objc  private func didTapCompose(){
        
        let vc = NewConversationViewController()
        vc.completion = {result in
            print(result)
            
            self.createNewConversation(result: result)
        }
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated:true )
        
    }
    
    public func createNewConversation(result:[String:String]){
        let vc = ChatViewController(with: result["safeEmail"]!)
        vc.isNewConversation=true
        vc.title = result["name"]
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func fetchUser(){
        
        tableView.isHidden=false
        
    }
    
    
    
    
    
}

extension ConversationViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsTableViewCell.identifier, for: indexPath) as! ConversationsTableViewCell
        let model = conversations[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
          let model = conversations[indexPath.row]
        let vc = ChatViewController(with: model.otherUserEmail)
        vc.title=model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    
}
