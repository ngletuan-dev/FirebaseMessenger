//
//  StorageManager.swift
//  FirebaseMessenger
//
//  Created by Tuấn Nguyễn on 21/01/2022.
//

import Foundation
import FirebaseStorage

/// Allows you to get, fetch, and upload files to firebase  storage
final class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    /*
     /images/ngletuan94-gmail-com_profile_picture.png
    */
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    ///Uploads picture firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard let strongSelf = self else {
                            return
                        }
            
            guard error == nil else {
                //failed
                print("Failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            strongSelf.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
            let reference = storage.child(path)

            reference.downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                completion(.success(url))
            })
        }
}
