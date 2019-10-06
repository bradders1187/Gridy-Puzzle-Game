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

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: IBOUTLETS
    @IBOutlet weak var gridyPickButton: UIButton!
    @IBOutlet weak var CameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    // MARK: VARIABLES
    var localImages = [UIImage]()
    let defaults = UserDefaults.standard
    var userChosenImage = UIImage()
    
    // MARK: IBACTIONS
    @IBAction func gridyPick(_ sender: Any) {
        pickRandom()
    }
    @IBAction func cameraPick(_ sender: Any) {
        displayCamera()
    }
    @IBAction func libraryPick(_ sender: Any) {
        displayLibrary()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: Checks access and status of camera
    func displayCamera() {
        let sourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let noPermissionMessage = "Gridy does not have access to use your camera. Please go to Settings>Gridy>Camera on your device to allow Gridy to use your Camera"
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch status {
            case .notDetermined :
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                    if granted {
                        self.presentPhoto(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                }
            case .authorized :
                self.presentPhoto(sourceType: sourceType)
            case .denied, .restricted :
                self.troubleAlert(message: noPermissionMessage)
            default:
                troubleAlert(message: "Oh No we can't access your camera right now")
            }
        } else {
            troubleAlert(message: "Oh No we can't access your camera right now")
        }
    }
    
    
    //MARK: check the access and status to the photo library before loading the view
    func displayLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            let noPermissionMessage = "Gridy does not have access to use your photos. Please go to Settings>Gridy>Photos on your device to allow Gridy to use your photo library"
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined :
                PHPhotoLibrary.requestAuthorization { (granted) in
                    if granted == .authorized {

                        self.presentPhoto(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                }
            case .authorized :
                self.presentPhoto(sourceType: sourceType)
            case .denied, .restricted :
                self.troubleAlert(message: noPermissionMessage)
            default:
                troubleAlert(message: "Sincere apologies, it looks like we can't access your photo library at this time")
            }
        } else {
            troubleAlert(message: "Sincere apologies, it looks like we can't access your photo library at this time")
        }
    }
    
    //MARK: Function to present camera or photo library
    func presentPhoto(sourceType: UIImagePickerController.SourceType) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = sourceType
        present(photoPicker, animated: true)
    }
    func troubleAlert(message: String?) {
        let alertController = UIAlertController(title: "Ooops", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let pickedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided with the following: \(info)")
        }
        userChosenImage = pickedImage
        performSegue(withIdentifier: "goToImageEditorViewController", sender: self)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Function to collect local images
    func collectLocalImages() {
        localImages.removeAll()
        let localImagesNames = ["fawn", "island", "lake", "mountain", "rabbit"]
        for name in localImagesNames {
            if let image = UIImage(named: name) {
                localImages.append(image)
            }
        }
    }
    private let localImageIndex = "imageIndex"
    private var lastImageIndex: Int {
        get {
            let savedIndex = defaults.value(forKey: localImageIndex)
            if savedIndex == nil {
                defaults.set(localImages.count - 1, forKey: localImageIndex)
            }
            return defaults.integer(forKey: localImageIndex)
        }
        set {
            if newValue >= 0 && newValue < localImages.count {
                defaults.set(newValue, forKey: localImageIndex)
            }
        }
    }
    
    //MARK: Function to randomly pick a local image to return the random image from the image set
    func randomImage() -> UIImage? {
        let lastPickedImage = localImages[lastImageIndex]
        if localImages.count > 0 {
            while true {
                let randomImageNumber = Int.random(in: 0...localImages.count - 1)
                let newImage = localImages[randomImageNumber]
                if newImage != lastPickedImage {
                    lastImageIndex = randomImageNumber
                    return newImage
                }
            }
        }
        return nil
    }
    func pickRandom() {
        userChosenImage = randomImage() ?? localImages[0]
        performSegue(withIdentifier: "goToImageEditorViewController", sender: self)
    }
    
    // MARK: Function to make buttons rounded
    func rounded(button: UIButton) {
        var roundedButton = RoundedButton()
        roundedButton.setButton(button)
        roundedButton.rounded()
    }
    
    //MARK: Function to group all configuration functionality
    func configure() {
        collectLocalImages()
        
        rounded(button: gridyPickButton)
        rounded(button: CameraButton)
        rounded(button: libraryButton)
        
    }
    
    // MARK: Segue function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToImageEditorViewController" {
        let destination = segue.destination as! ImageEditorViewController
        destination.passedImage = userChosenImage
        }
    }
}
