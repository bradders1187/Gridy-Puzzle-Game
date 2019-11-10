//
//  ImageEditorView.swift
//  Gridy
//
//  Created by Peter Bradtke on 29/08/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit
import CoreImage

class ImageEditorView: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var adjustThePuzzleImageLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var creationFrame: UIView!
    @IBOutlet weak var creationImageView: UIImageView!
    @IBAction func StartButton(_ sender: UIButton) {
        setImageToSend()
    }
    @IBAction func XButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var incomingImage: UIImage?
    var initialImageViewOffset = CGPoint()
    var defaults = UserDefaults.standard
    var identity = CGAffineTransform.identity
    var panRecognizer: UIPanGestureRecognizer?
    var pinchRecognizer: UIPinchGestureRecognizer?
    var rotateRecognizer: UIRotationGestureRecognizer?
    var toSend = [UIImage]()
    var screenshot = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        
        // Create gesture with target self(viewcontroller) and handler function.
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        self.pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(recognizer:)))
        self.rotateRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotate(recognizer:)))
        
        //delegate gesture with UIGestureRecognizerDelegate
        pinchRecognizer?.delegate = self
        rotateRecognizer?.delegate = self
        panRecognizer?.delegate = self
        
        // add gesture to creation.imageView
        self.creationImageView.addGestureRecognizer(panRecognizer!)
        self.creationImageView.addGestureRecognizer(pinchRecognizer!)
        self.creationImageView.addGestureRecognizer(rotateRecognizer!)
    }
    
    func setImage() {
        if let myImage = incomingImage {
            creationImageView.image = myImage
            backgroundImage.image = myImage
        }
    }
    
    // handle UIPanGestureRecognizer
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let gview = recognizer.view
        if recognizer.state == .began || recognizer.state == .changed {
            let translation = recognizer.translation(in: gview?.superview)
            gview?.center = CGPoint(x: (gview?.center.x)! + translation.x, y: (gview?.center.y)! + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: gview?.superview)
        }
    }
    
    // handle UIPinchGestureRecognizer
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            recognizer.view?.transform = (recognizer.view?.transform.scaledBy(x: recognizer.scale, y: recognizer.scale))!
            recognizer.scale = 1.0
        }
    }
    
    // handle UIRotationGestureRecognizer
    @objc func handleRotate(recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            recognizer.view?.transform = (recognizer.view?.transform.rotated(by: recognizer.rotation))!
            recognizer.rotation = 0.0
        }
    }
    
    // mark sure you override this function to make gestures work together
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // simultaneous gesture recognition will only be supported for creationImageView
        if gestureRecognizer.view != creationImageView {
            return false
        }
        // neither of the recognized gestures should not be tap gesture
        if gestureRecognizer is UITapGestureRecognizer
            || otherGestureRecognizer is UITapGestureRecognizer
            || gestureRecognizer is UIPanGestureRecognizer
            || otherGestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        return true
    }
    
    func composeCreationImage(completion: @escaping (UIImage) -> Void) {
        DispatchQueue.main.async {
            UIGraphicsBeginImageContextWithOptions(self.creationFrame.bounds.size, false, 0)
            self.creationFrame.drawHierarchy(in: self.creationFrame.bounds, afterScreenUpdates: true)
            self.screenshot = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            completion(self.screenshot)
        }
    }
    
    func slice(screenshot: UIImage, into howMany: Int) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat

        switch screenshot.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = screenshot.size.height
            height = screenshot.size.width
        default:
            width = screenshot.size.width
            height = screenshot.size.height
        }

        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))

        let scale = Int(screenshot.scale)
        var images = [UIImage]()
        let cgImage = screenshot.cgImage!

        var adjustedHeight = tileHeight

        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCGImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCGImage, scale: screenshot.scale, orientation: screenshot.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }
    
    func setImageToSend() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.composeCreationImage { image in
                self.toSend = self.slice(screenshot: image, into: 4)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "my2ndSegue", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "my2ndSegue" {
            let vc2 = segue.destination as! PuzzleController
            vc2.toReceive = toSend
            vc2.popUpImage = self.screenshot
        }
    }
}


    
    
    
    

