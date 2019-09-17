//
//  ViewController.swift
//  Gridy
//
//  Created by Peter Bradtke on 17/08/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
    
    //Outlets
    @IBOutlet weak var gridyLogo: UIImageView!
    @IBOutlet weak var orLoadYourOwnLabel: UILabel!
    @IBOutlet weak var challengeYourselfLabel: UILabel!
    
    // Variables and Constants
    var creation = Creation.init()
    var localImages = [UIImage].init()
    let imagePickerController = UIImagePickerController()
    var newImage = UIImage.init()
    
    
    //Functions
    @IBAction func cameraButton(_ sender: UIButton) {
        displayCamera()
    }
    @IBAction func photoLibraryButton(_ sender: UIButton) {
        displayLibrary()
    }
    @IBAction func pickButton(_ sender: UIButton) {
        pickRandom()
    
    }
    
    //Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mySegue" {
            _ = segue.destination as! ImageEditorView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectLocalImageSet()
    }
    
    //Access to camera and libary
    func displayCamera() {
        let sourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            let noPermissionMessage = "Looks like Gridy doesn't have access to your camera 😔 Please use Settings app on your device to permit Gridy accessing your camera"
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(granted) in
                    if granted {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            @unknown default:
                fatalError(noPermissionMessage)
            }
        }
        else {
            troubleAlert(message: "Oh no! We can't access your camera right now!📷")
        }
    }
    
    func displayLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = PHPhotoLibrary.authorizationStatus()
            let noPermissionStatusMessage = "Oh no it looks like we can't gain access to your photo libary right now! 😔 Please go to your iPhone settings to change Gridy's permissions"
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionStatusMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionStatusMessage)
            @unknown default:
                self.presentImagePicker(sourceType: sourceType)
                
            }
        }
        else {
            troubleAlert(message: "Oh no it looks like we can't gain access to your photo libary right now! 😔 Please go to your iPhone settings to change Gridy's permissions")
        }
    }
    //Image picker
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        processPicked(image: newImage)
        dismiss(animated: true, completion: { () -> Void in
            self.performSegue(withIdentifier: "mySegue", sender: self)
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func troubleAlert(message: String?) {
        let alertController = UIAlertController(title: "Oops...😔", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it.😁", style: .cancel)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    func pickRandom() {
        processPicked(image: randomImage())
        performSegue(withIdentifier: "mySegue", sender: self)
    }
    func processPicked(image: UIImage?) {
        if  let newImage = image {
            creation.image = newImage
        }
    }
    func randomImage() -> UIImage? {
        let currentImage = creation.image
        if localImages.count > 0 {
            while true {
                let randomIndex = Int(arc4random_uniform(UInt32(localImages.count)))
                let newImage = localImages[randomIndex]
                if newImage != currentImage {
                    return newImage
                }
            }
        }
        return nil
    }
    func collectLocalImageSet() {
        localImages.removeAll()
        let imageNames = ["Fawn", "Island", "Lake", "Mountain", "Rabbit", "Wood"]
        for name in imageNames {
            if let image = UIImage.init(named: name) {
                localImages.append(image)
            }
        }
    }
    
}
