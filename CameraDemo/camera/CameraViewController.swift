//
//  CameraViewController.swift
//  CameraDemo
//
//  Created by LozyLoop on 03/03/2021.
//  Copyright © 2021 LozyLoop. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var takeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI(){
        self.navigationController?.isNavigationBarHidden = true
        imageView.backgroundColor = .secondarySystemBackground
    }
    
    func handleImageController(type: Int){
        let sourceType: UIImagePickerController.SourceType = type == 1 ? .camera : .photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let controller = UIImagePickerController()
            controller.sourceType = sourceType
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        } else {
           //error
        }
    }
    
    func alertCameraAccessNeeded() {
        let settingsAction = UIAlertAction(title: "Allow Camera", style: .default) { (_) -> Void in

            guard let settingsAppURL = URL(string: UIApplication.openSettingsURLString) else {
                       return
                   }
            
            if UIApplication.shared.canOpenURL(settingsAppURL) {
                UIApplication.shared.open(settingsAppURL, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
     
         let alert = UIAlertController(
             title: "Need Camera Access",
             message: "Camera access is required to make full use of this app.",
             preferredStyle: UIAlertController.Style.alert
         )
        
        alert.addAction(settingsAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func TakePicture(_ sender: UIButton){        
        checkPermissionsCamera()
    }
    
    @IBAction func SelectLibbrary(_ sender: UIButton){
        checkPermissionsPhoto()
    }
    
    func checkPermissionsCamera(){
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined: requestCameraPermission()
        case .authorized: handleImageController(type: 1)
        case .restricted, .denied: alertCameraAccessNeeded()
        }
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            self.handleImageController(type: 1)
        })
    }
    
    func checkPermissionsPhoto() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case PHAuthorizationStatus.authorized:
            handleImageController(type: 0)
        default:
            PHPhotoLibrary
                        .requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            handleImageController(type: 0)
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
