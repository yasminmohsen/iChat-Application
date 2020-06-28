//
//  StorageManager.swift
//  IChat
//
//  Created by yasmin mohsen on 6/28/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias uploadPictureCompletion = (Result<String,Error>)->Void
    /// upload photo to firebase storage and return a completion with url  string to download
    
    public func uploadProfilePicture (with data : Data ,fileName: String ,completion :@escaping uploadPictureCompletion){
        
        storage.child("images/\(fileName)").putData(data, metadata: nil,completion: {metadata,error in
            
            guard error == nil else{
                // failed
                print ("failed to upload photo to firebase")
                completion (.failure(storageError.failedToUpload))
                return
            }
            let refrence = self.storage.child("images/\(fileName)").downloadURL { (url, error) in
                
                guard let url = url else{
                    
                    print ("failed to download photo")
                    completion(.failure(storageError.failedTodownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                completion(.success(urlString))
            }
        })
        
    }

    
    
    public enum storageError :Error{
        
        case failedToUpload
         case failedTodownloadUrl
        
    }
    
    public func downloadUrl (path:String ,completeion: @escaping(Result<URL,Error>)->Void){
        
        let refrence = storage.child(path)
        refrence.downloadURL(completion: {url,error in
            
            guard  let url = url ,error == nil  else{
                
                completeion(.failure(storageError.failedTodownloadUrl))
                return
            }
            
            completeion(.success(url))
            
        })
        
    }
}
