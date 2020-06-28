//
//  ProfileViewController.swift
//  IChat
//
//  Created by yasmin mohsen on 6/26/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let data = ["Log out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate=self
        tableView.dataSource=self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    

  

}


extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text=data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        do {
            
           try FirebaseAuth.Auth.auth().signOut()
            
            
               let vc=LoginViewController()
                          let nav = UINavigationController(rootViewController: vc)
                          nav.modalPresentationStyle = .fullScreen
                          present(nav,animated: true)
        }
        catch{
            
        }
    }
    
}
