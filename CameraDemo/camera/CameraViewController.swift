//
//  CameraViewController.swift
//  CameraDemo
//
//  Created by LozyLoop on 03/03/2021.
//  Copyright © 2021 LozyLoop. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var takeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkPermissions()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI(){
        self.navigationController?.isNavigationBarHidden = true
        imageView.backgroundColor = .secondarySystemBackground
    }
    
    @IBAction func TakePicture(_ sender: UIButton){        
        let sourceType: UIImagePickerController.SourceType = .camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let controller = UIImagePickerController()
            controller.sourceType = sourceType
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        } else {
           //error camera
        }
    }
    
    @IBAction func SelectLibbrary(_ sender: UIButton){
        let sourceType: UIImagePickerController.SourceType = .photoLibrary
           if UIImagePickerController.isSourceTypeAvailable(sourceType) {
               let photocontroller = UIImagePickerController()
               photocontroller.delegate = self
               photocontroller.sourceType = sourceType
               photocontroller.allowsEditing = true
               present(photocontroller, animated: true, completion: nil)
           } else {
              //error camera
           }
    }
    
    func checkPermissions() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in ()
            })
        }

        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
        } else {
            PHPhotoLibrary
                .requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("Access granted to use Photo Library")
        } else {
            print("We don't have access to your Photos.")
        }
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage else {
            return
        }
        imageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
