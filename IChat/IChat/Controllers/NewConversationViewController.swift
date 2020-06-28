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

    
    private let spinner = JGProgressHUD()
    private let searchbar :UISearchBar = {
       let searchbar = UISearchBar()
        searchbar.placeholder="Search For Friends ..."
        
        
     return searchbar
    }()
    
    
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
        searchbar.delegate=self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView=searchbar
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        
        searchbar.becomeFirstResponder()
    }
    

    // selectors :
    
    @objc private func dismissSelf(){
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    

}

extension NewConversationViewController :UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}
