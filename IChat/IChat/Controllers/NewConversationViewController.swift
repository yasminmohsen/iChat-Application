//
//  NewConversationViewController.swift
//  IChat
//
//  Created by yasmin mohsen on 6/26/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {

    public var completion: (([String:String])->Void)?
    private let spinner = JGProgressHUD(style: .dark)
    private let searchbar :UISearchBar = {
       let searchbar = UISearchBar()
        searchbar.placeholder="Search For Friends ..."
        
        
     return searchbar
    }()
    
    
    private  var users=[[String:String]]()
      private  var results=[[String:String]]()
    
    private var hasFetched = false
    
    private let tableView :UITableView = {
      let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden=true
    return table
    }()
    
    
    private let noResultLabel : UILabel = {
        
        let label = UILabel()
        label.text="No Result Found "
        label.textAlignment = .center
        label.textColor = .gray
        label.font=UIFont.systemFont(ofSize: 20, weight: .medium)
        label.isHidden=true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
        tableView.delegate=self
        tableView.dataSource=self
        
        searchbar.delegate=self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView=searchbar
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        
        searchbar.becomeFirstResponder()
    }
    

    override func viewDidLayoutSubviews() {
        tableView.frame=view.bounds
        noResultLabel.frame=CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    
    // selectors :
    
    @objc private func dismissSelf(){
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    

}

extension NewConversationViewController :UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text , !(searchBar.text?.replacingOccurrences(of: " ", with: "").isEmpty)! else{
            
            return
        }
        
        searchBar.resignFirstResponder()
        results.removeAll()
        spinner.show(in: view)
    searchUsers(query: text)
        
    }
   
    func searchUsers(query:String){
        
        // check if the array has firebase result
        
        if hasFetched{
            filterUser(item: query)
        }
        
        else{
            DatabaseManager.shared.getallUser(completion: {result in
                
                switch result {
                    
                case .success(let usersArray) :
                    self.hasFetched=true
                    self.users = usersArray
                    self.filterUser(item: query)
                    
                case .failure(let error):
                    
                    print("Error is /\(error) ")
                }
                
            
                
            })
        }
    }
    
    public func filterUser(item :String){
        
        
        guard hasFetched else {
            
            return
        }
        
        self.spinner.dismiss()
        var results:[[String:String]]=self.users.filter({
            
            guard let name=$0["name"]?.lowercased() else{
                
                return false
                
            }
            return name.hasPrefix(item.lowercased())
        })
        self.results=results
        updateUi ()
    }
    
    
    func updateUi (){
        
        if results.isEmpty{
            
            self.noResultLabel.isHidden=false
             self.tableView.isHidden=true
        }
        else{
            
            self.noResultLabel.isHidden=true
                       self.tableView.isHidden=false
            tableView.reloadData()
        }
        
    }
}



extension NewConversationViewController :UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text=results[indexPath.row]["name"]
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        //after choosing one user :
        let targetUer=results[indexPath.row]
        
        dismiss(animated: true) {
            self.completion?(targetUer)
        }
        
    }
    
    
    
    
    
    
}
