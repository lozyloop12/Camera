//
//  CameraViewController.swift
//  CameraDemo
//
//  Created by LozyLoop on 03/03/2021.
//  Copyright © 2021 LozyLoop. All rights reserved.
//

import UIKit

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
    
    @IBAction func TakePicture(_ sender: UIButton){        
        let sourceType: UIImagePickerController.SourceType = .camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let controller = UIImagePickerController()
            controller.sourceType = sourceType
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        } else {
           //errỏ camera
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        imageView.image = image
    }
}

