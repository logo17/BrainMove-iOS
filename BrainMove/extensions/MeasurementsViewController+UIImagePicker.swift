//
//  MeasurementsViewController+UIImagePicker.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 7/2/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import UIKit

extension MeasurementsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageData = selectedImage.jpegData(compressionQuality: 1.0)
            dismiss(animated: true, completion: nil)
            uploadImage()
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

