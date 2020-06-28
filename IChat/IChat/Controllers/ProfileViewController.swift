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

       tableView.tableHeaderView = createTableViewHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          tableView.tableHeaderView = createTableViewHeader()
    }
      
    
    

    func createTableViewHeader()->UIView?{
        
     
        let safeEmail=DatabaseManager.safeEmail(email: (Auth.auth().currentUser?.email)!)
        let fileName = safeEmail+"_profile_picture.png"
        let path = "images/\(fileName)"
        let headerView = UIView(frame:CGRect(x: 0, y: 0, width: self.view.width, height: 300))
        headerView.backgroundColor = .link
        
        let imageView = UIImageView(frame: CGRect(x: (headerView.width-150)/2, y: 75, width: 150, height: 150))
    
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds=true
        imageView.layer.cornerRadius=imageView.frame.width/2
        StorageManager.shared.downloadUrl(path: path, completeion: {result in
            
            switch result {
                
            case .success(let url):
                 print ("Sucess")
                 self.downloadImage(imageView: imageView, url: url)
            case .failure(let error):
                print ("failed to get the url")
                
            }
            
            
        })
        
        headerView.addSubview(imageView)
    
        return headerView
    }

    func downloadImage(imageView:UIImageView,url:URL){
        
        URLSession.shared.dataTask(with: url, completionHandler: {data,_,error in
            
            guard let data = data , error == nil else{
                
                
                return
            }
            
            DispatchQueue.main.async {
                 let image=UIImage(data:data)
                imageView.image=image
            }
            
           
            }).resume()
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
