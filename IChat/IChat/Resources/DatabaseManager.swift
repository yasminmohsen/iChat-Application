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
    
    
}
struct ChatAppUser {
    let firstName:String
    let lastName:String
    let email:String
    let profilePic:String
    
    var safeEmail: String{
        
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
    
    
    
    public func insertUser(with user:ChatAppUser){
          
            database.child(user.safeEmail).setValue([
                "first_name":user.firstName ,
                "last_name": user.lastName
            
            ])
            
    }
    
}
