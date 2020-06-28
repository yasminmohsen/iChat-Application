//
//  DatabaseManager.swift
//  IChat
//
//  Created by yasmin mohsen on 6/27/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared=DatabaseManager()
    private let database=Database.database().reference()
    
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
