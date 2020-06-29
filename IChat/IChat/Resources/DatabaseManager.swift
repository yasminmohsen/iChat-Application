//
//  DatabaseManager.swift
//  IChat
//
//  Created by yasmin mohsen on 6/27/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

final class DatabaseManager {
    
    static let shared=DatabaseManager()
    private let database=Database.database().reference()
    let userEmail = (Auth.auth().currentUser?.email)!
    
    static func safeEmail(email :String)->String{
          
          var safeEmail=email.replacingOccurrences(of: ".", with: "-")
                 safeEmail=safeEmail.replacingOccurrences(of: "@", with: "-")
                return safeEmail
      }
    
}

extension DatabaseManager {
    
    public func userExists(with email : String ,completion :@escaping (Bool)->Void){
        
        var safeEmail=email.replacingOccurrences(of: ".", with: "-")
        safeEmail=safeEmail.replacingOccurrences(of: "@", with: "-")
     
        database.child(safeEmail).observeSingleEvent(of: .value, with:{ snapshot in
            
            
            guard let foundEmail=snapshot.value as? String else{
                completion(false)
                return
            }
            completion(true)
        })
    
}
    
    
    
    public func insertUser(with user:ChatAppUser ,completion :@escaping (Bool)->Void){
          
            database.child(user.safeEmail).setValue([
                "first_name":user.firstName ,
                "last_name": user.lastName
            
                ], withCompletionBlock: {error ,_ in
                    
                    guard error == nil else{
                         print (" failed to write data to firebase")
                        completion(false)
                      return
                    }
                    
                    // to add users in collection of users :
                    
                    // user schema database :
                    
                    // user :
                    /*
                    name : ""
                    safeEmail :""
                    */
                    self.database.child("users").observeSingleEvent(of: .value, with: {snapshot in
                        
                        if var userCollection=snapshot.value as?[[String:String]]{
                            let newUser=[
                            
                                "name" :user.firstName + " " + user.lastName ,
                                "safeEmail" : user.safeEmail
                            ]
                            
                            userCollection.append(newUser)
                            
                            self.database.child("users").setValue(userCollection,withCompletionBlock: {error,_ in
                                
                                guard error == nil else{
                                    completion(false)
                                    return
                                }
                                
                                 completion(true)
                            })
                            //append users in the array
                            
                        }
                        else{
                            //create new array
                            let newCollection:[[String:String]] = [
                            [
                                "name" :user.firstName + " " + user.lastName ,
                                "safeEmail" : user.safeEmail
                            
                            ]
                            ]
                            self.database.child("users").setValue(newCollection,withCompletionBlock: {error,_ in
                                
                                guard error == nil else{
                                    completion(false)
                                    return
                                }
                                
                                 completion(true)
                            })
                        }
                        
                        
                    })
                    
                    
                   
            })
            
    }
    
    
    
    public func getallUser (completion:@escaping (Result<[[String:String]], Error>)->Void){
        
        database.child("users").observeSingleEvent(of: .value, with: {snapshot in
        
        
            guard let value = snapshot.value as?[[String:String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            
            completion(.success(value))
            
        })
        
        
    }
    public enum DatabaseError :Error{
          
          case failedToFetch
       
      }
}


struct ChatAppUser {
    let firstName:String
    let lastName:String
    let email:String
    
    var safeEmail: String{
        
        var safeEmail=email.replacingOccurrences(of: ".", with: "-")
         safeEmail=safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName :String {
        
        return "\(safeEmail)_profile_picture.png"
    }
    
    
  
}


//MARK: - Sending Messages/Conversation
extension DatabaseManager{

    /*
     conversation schema database
     "sssssssss"{
     "messages":[
     {
     "id" : string
     "type":text,photo,vedio
     "content": based on type //
     "date":Date()
     "sendr_email":string
     "isReda":true/false
     
     }
     ]
     }
     
     
     
     
    ** conversation :
     "conversationId": "sssssssss"
     "other_user_email":
     latest_message : {
     "date":Date()
     "lateset_message" : "message"
     "is_read":true/false
     }
     */
    
    
    
    
    /// create new conversation with  target user email and first message
    
    public func createNewConversation(with otherUserEmail:String ,otherUserName:String,firstMessage:Message, completion:@escaping (Bool)->Void){
        
      
        let safeEmail=DatabaseManager.safeEmail(email: userEmail)
        let refrence = database.child("\(safeEmail)")
        let conversationId = "conversation_\(firstMessage.messageId)"
        refrence.observeSingleEvent(of: .value, with: { snapshot in
            
            guard var userNode=snapshot.value as?[String:Any] else{
                completion(false)
                print("user not found")
              return
            }
            let messageDate=firstMessage.sentDate
            let dateString=ChatViewController.dateFormatter.string(from: messageDate) // to save it in database
            var sentMessage=""
            
            switch firstMessage.kind {
                
            case .text(let textMessage):
                sentMessage=textMessage
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
            @unknown default:
                break
            }
            
            
            
            
            let newConversationData: [String:Any] = [
                
                "id" : conversationId,
                "other_user_email" : otherUserEmail,
                "otherUserName" : otherUserName,
                "latest_message" : [
                    
                    "date":dateString,
                    "message" : sentMessage,
                    "is_read":false
                ]
            ]
            
            
            
            if var conversations = userNode["conversations"] as? [[String:Any]]{
                // converstion exisit for this user you should append
                conversations.append(newConversationData)
                 userNode["conversations"]=conversations
                refrence.setValue(userNode, withCompletionBlock: {error,_ in
                                 
                                 guard error == nil else {
                                     
                                     completion (false)
                                     return
                                 }
                                self.finishCreateConversation(otherUserName : otherUserName,conversationId: conversationId, firstMessage: firstMessage, completeion: completion)
                             })
                
            }
            else{
          // create new convesration
                
                userNode["conversations"]=[
                
                newConversationData
                ]
                
                refrence.setValue(userNode, withCompletionBlock: {error,_ in
                    
                    guard error == nil else {
                        
                        completion (false)
                        return
                    }
                    self.finishCreateConversation(otherUserName : otherUserName, conversationId: conversationId, firstMessage: firstMessage, completeion: completion) // we replace func completeion with createNewConversation completeion
                    
                })
            }
        })
        

    }
    
    
    private func finishCreateConversation(otherUserName : String
        ,conversationId:String ,firstMessage:Message ,completeion:@escaping (Bool)->Void){
        
        let messageDate=firstMessage.sentDate
        let dateString=ChatViewController.dateFormatter.string(from: messageDate) // to save it in database
       var  sentMessage = ""
   switch firstMessage.kind {
                      
                  case .text(let textMessage):
                     sentMessage = textMessage
                  case .attributedText(_):
                      break
                  case .photo(_):
                      break
                  case .video(_):
                      break
                  case .location(_):
                      break
                  case .emoji(_):
                      break
                  case .audio(_):
                      break
                  case .contact(_):
                      break
                  case .custom(_):
                      break
                  @unknown default:
                      break
                  }
        
        
        let message : [String :Any]=[
            "id" : firstMessage.messageId,
            "type": firstMessage.kind.description,
            "content":sentMessage ,
            "date": dateString,
            "sendr_email": userEmail,
            "isReda":false,
            "otherUserName":otherUserName
        
        
        ]
        
        
        let value :[String:Any]=[
        
            "messages" :[message]
        
        
        ]
        database.child("\(conversationId)").setValue(value, withCompletionBlock: {error,_ in
            
            guard error == nil else{
                
                completeion(false)
                return
            }
            
             completeion(true)
            
        })
        

          
      }
    
    
    
    
    
    /// fetch all conversation for a paased user email
    public func getAllConversation(for email:String ,completion:@escaping (Result<[Conversation],Error>)->Void){
          
        
        
        database.child("\(email)/conversations").observe(.value, with: {snapshot in
            
            guard let conversation = snapshot.value as? [[String:Any]] else{
                
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let conArray:[Conversation] = conversation.compactMap({ dictionary in
                
                guard let conversationId = dictionary["id"] as?String ,
                let  otherUserName = dictionary["otherUserName"] as?String,
                    let otherUserEmail = dictionary["other_user_email"] as?String,
                    let lastestMessage = dictionary["latest_message"] as?[String:Any],
                   let date = lastestMessage["date"] as? String,
                    let isRead = lastestMessage["is_read"] as? Bool,
                 let message=lastestMessage["message"] as? String
                 
                    else{
                        return nil
                }
               
                
              let latestMsgObj=LatestMessage(date: date, text: message, isRead: isRead)
                
                
                return Conversation(id: conversationId, name: otherUserName, otherUserEmail: otherUserEmail, latestMessage: latestMsgObj)
            })
            
            
            completion(.success(conArray))
            
        })
      }
    
    public func getAllMessagesForOneConversation(for id:String ,completion:@escaping (Result<String,Error>)->Void){
        
        
        
    }
    
    
    public func sendMessageToConversation( to conversation:String,message:Message ,completion:@escaping (Bool)->Void){
        
        
        
    }
}
