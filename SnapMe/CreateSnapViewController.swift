//
//  CreateSnapViewController.swift
//  SnapMe
//
//  Created by Akshar Shrivats on 7/24/19.
//  Copyright © 2019 Akshar Shrivats. All rights reserved.
//

import UIKit
import FirebaseStorage

class CreateSnapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noteTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var imageName = "\(NSUUID().uuidString).jpeg"
    var imageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        let imagesFolder = Storage.storage().reference().child("images")
        
        if let image = imageView.image{
            if let imageData = image.jpegData(compressionQuality: 0.8){
                imagesFolder.child(imageName).putData(imageData, metadata: nil) { (metaData, error) in
                    if let error = error {
                        print (error)
                    } else {
                        imagesFolder.child(self.imageName).downloadURL(completion: { (url, error) in
                            if let imageURL = url?.absoluteString{
                                self.imageURL = imageURL
                                self.performSegue(withIdentifier: "moveToSender", sender: nil)
                            }
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func choosePhotoTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectVC = segue.destination as? SelectUserTableViewController {
            selectVC.imageName = imageName
            selectVC.imageURL = imageURL
            if let message = noteTextField.text {
                selectVC.message = message
            }
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
