//
//  ImageUploader.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 7/2/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import Cloudinary
import FirebaseAuth

class ImageUploader {
    private let cloudinary: CLDCloudinary
    
    init() {
        let config = CLDConfiguration(cloudName: Constants.cloudName, apiKey: Constants.apiKey, apiSecret: Constants.apiSecret)
        self.cloudinary = CLDCloudinary(configuration: config)
    }
    
    func uploadImage(data: Data, completion: @escaping (String) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion("")
            return
        }
        
        let params = CLDUploadRequestParams()
        params.setPublicId("\(user.uid)")
        params.setInvalidate(true)
        params.setOverwrite(true)
        self.cloudinary.createUploader().signedUpload(data: data, params: params
            , progress: { progress in
                
        }) { (result, error) in
            guard result != nil else {
                completion("")
                return
            }
            
            let photoUrl = result?.secureUrl ?? ""
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.photoURL = URL(string: photoUrl)
            changeRequest.commitChanges { (error) in
                completion(photoUrl)
                print(error ?? "No error")
            }
        }
    }
    
}
