//
//  ConversationsTableViewCell.swift
//  IChat
//
//  Created by yasmin mohsen on 6/29/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import UIKit
import SDWebImage

class ConversationsTableViewCell: UITableViewCell {
    
    static let identifier = "ConversationsTableViewCell"
    
    private let  userImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius=50
        imageView.layer.masksToBounds=true
      
        
        return imageView
    }()
    
    
    
    private let userNameLabel : UILabel = {
        
        let label = UILabel()
        label.font=UIFont.systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    
    private let userMessage : UILabel = {
         
         let label = UILabel()
         label.font=UIFont.systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines=0
         return label
     }()
     
    
//    private let history : UILabel = {
//
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font=UIFont.systemFont(ofSize: 19, weight: .regular)
//        label.text="11:20"
//        return label
//    }()
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessage)
//
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.frame=CGRect(x: 10, y: 10, width: 100, height: 100)
        
        userNameLabel.frame=CGRect(x: userImageView.right + 10, y: 10, width: contentView.width - 20 - userImageView.width, height:(contentView.height - 20)/2)
       userMessage.frame=CGRect(x: userImageView.right + 10, y: userNameLabel.bottom + 10, width: contentView.width - 20 - userImageView.width, height:((contentView.height - 20)/2) )
    }
    
    public func configure(with model :Conversation){
        
        print(model)
        self.userMessage.text = model.latestMessage.text
        self.userNameLabel.text = model.name
       
        let path = "images/\(model.otherUserEmail)_profile_picture.png"
        StorageManager.shared.downloadUrl(path: path, completeion: {result in
            
            switch result{
                
                
                
            case .success(let url):
                
                DispatchQueue.main.async {
                     self.userImageView.sd_setImage(with: url, completed: nil)
                }
                
               
                
            case .failure(let error):
                
                print ("can't get image path")
            }
            
            
        })
    }
}
