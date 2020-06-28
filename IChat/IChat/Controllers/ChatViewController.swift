//
//  ChatViewController.swift
//  IChat
//
//  Created by yasmin mohsen on 6/28/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import UIKit
import MessageKit


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
class ChatViewController: MessagesViewController {

    private  var message=[Message]()
    private var selfSender = sender(senderId: "1", displayName: "yasmin mohsen", photoURL: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        message.append(Message(sender: selfSender
            , messageId: "1", sentDate: Date(), kind: .text("hello world")))
        message.append(Message(sender: selfSender
                   , messageId: "1", sentDate: Date(), kind: .text("hello world from other side")))
               
        view.backgroundColor = .systemTeal
        messagesCollectionView.messagesDataSource=self
        messagesCollectionView.messagesLayoutDelegate=self
        messagesCollectionView.messagesDisplayDelegate=self
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
