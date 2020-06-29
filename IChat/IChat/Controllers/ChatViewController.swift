//
//  ChatViewController.swift
//  IChat
//
//  Created by yasmin mohsen on 6/28/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseAuth


struct Message:MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
}



struct sender:SenderType {
    var senderId: String
    var displayName: String
    var photoURL:String
}



extension MessageKind{
    var description: String{
        
        switch self{
            
        case .text(_):
            return "text"
        case .attributedText(_):
             return "attributedText"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .custom(_):
            return "custom"
        @unknown default:
            break
        }
    }
    
    
}



class ChatViewController: MessagesViewController {

    
    
    public static var dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
         formatter.dateStyle = .medium
         formatter.timeStyle = .long
         formatter.locale = .current
         
         return formatter
     }()
    
    
    public var otherUserEmail:String!
     public var userName:String!
    public var isNewConversation=false
    
    private  var message=[Message]()
    private var selfSender = sender(senderId:(Auth.auth().currentUser?.email)! , displayName: "yasmin mohsen", photoURL: "")
    

    init(with email:String){
        
     super .init(nibName: nil, bundle: nil)
        self.otherUserEmail=email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
 
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
               
        view.backgroundColor = .systemTeal
        messagesCollectionView.messagesDataSource=self
        messagesCollectionView.messagesLayoutDelegate=self
        messagesCollectionView.messagesDisplayDelegate=self
        messageInputBar.delegate=self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messageInputBar.inputTextView.resignFirstResponder()
    }

}


extension ChatViewController:InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty
              else {
            return
        }
         let messageId=createRandomEMessageId()
        
        if isNewConversation{
           
           let message = Message(sender: selfSender,
                                messageId: messageId,
                                sentDate: Date(),
                                kind: .text(text))
            
            
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, otherUserName: self.title ?? "User", firstMessage: message, completion: {sucess in
                
                if sucess {
                    print("Messsage sent")
                }
                else{
                    print("Messsage failed to send")
                    
                }
                
            })
        }
        else{
            // append convrstaion
        }
    }
    
    public func createRandomEMessageId()->String{
        
        let dateString=Self.dateFormatter.string(from: Date())
        // random id : date+otherUserEmail+selfSenderEmail+random int
        
        let email = (Auth.auth().currentUser?.email)!
        let userEmail = DatabaseManager.safeEmail(email: email)
        print ("user email is " + (Auth.auth().currentUser?.email)!)
        
        var newIdentifier = (otherUserEmail)! + userEmail + (dateString)
        print("new Identifier is : \(newIdentifier)")
        return newIdentifier
    }
    
    
  
    
}


extension ChatViewController :MessagesDataSource,MessagesLayoutDelegate ,MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return message[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
      return  message.count
    }
    
    
    
    
    
    
}
