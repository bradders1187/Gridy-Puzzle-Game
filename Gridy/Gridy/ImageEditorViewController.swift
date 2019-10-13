//
//  ImageEditorView.swift
//  Gridy
//
//  Created by Peter Bradtke on 29/08/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit

import UIKit

class ImageEditorViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: IB Variables
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cropImageBoxView: UIView!
    @IBOutlet weak var userChosenImage: UIImageView!
    @IBOutlet weak var gridView: UIImageView!
    //MARK: IBFUNCTIONS
    @IBAction func closeButton(_ sender: Any){ navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func startButton(_ sender: Any) {
        performSegue(withIdentifier: "goToPuzzleController", sender: self)
        userChosenImage.transform = .identity
    }
    
    var passedImage: UIImage?
    
    override func viewDidLoad() {
           super.viewDidLoad()
           configure()
       }
    //MARK: Function to draw a grid on the grid view
    func drawing() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: gridView.frame.width, height: gridView.frame.height))
        let gridDrawer = Grid()
        let image = renderer.image { (ctx) in
            gridDrawer.drawGrid(context: ctx, squareDimension: cropImageBoxView.frame.height)
        }
        gridView.image = image
    }
    
    //MARK: Function to take a screenshot the size of cropImageBoxView
    func cropImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(cropImageBoxView.bounds.size, false, 0)
        cropImageBoxView.drawHierarchy(in: cropImageBoxView.bounds, afterScreenUpdates: true)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return screenShot
    }
    //MARK: Segue to puzzle controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPuzzleController" {
            let destination = segue.destination as! PuzzleController
            destination.gameImage = cropImage()
        }
    }
    
    //MARK: Function to group all configuration functionality
    func configure() {
        drawing()
        gestureRecognisres()
        rounded(button: startButton)
        userChosenImage.image = passedImage
    }
    
    //MARK: Function to set up the gestures recognisers
    func gestureRecognisres() {
        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action:#selector(moveImageView(_:)))
        userChosenImage.addGestureRecognizer(panGestureRecogniser)
        let rotationGestureRecogniser = UIRotationGestureRecognizer(target: self, action:#selector(rotateImageView(_:)))
        userChosenImage.addGestureRecognizer(rotationGestureRecogniser)
        let pinchGestureRecogniser = UIPinchGestureRecognizer(target: self, action: #selector(scaleImageView(_:)))
        userChosenImage.addGestureRecognizer(pinchGestureRecogniser)
        panGestureRecogniser.delegate = self
        rotationGestureRecogniser.delegate = self
        pinchGestureRecogniser.delegate = self
    }
    
    //MARK: Function to enable multitouch gestures
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view != userChosenImage {
            return false
        }
        if gestureRecognizer is UITapGestureRecognizer
            || otherGestureRecognizer is UITapGestureRecognizer {
            return false
        }
        return true
    }
    
    private var initialImageViewOffset = CGPoint()
    @objc func moveImageView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: userChosenImage.superview)
        if sender.state == .began {
            initialImageViewOffset = userChosenImage.frame.origin
        }
        let position = CGPoint(x: translation.x + initialImageViewOffset.x - userChosenImage.frame.origin.x, y: translation.y + initialImageViewOffset.y - userChosenImage.frame.origin.y)
        userChosenImage.transform = userChosenImage.transform.translatedBy(x: position.x, y: position.y)
    }
    
    // MARK: set the rotation functionality
    @objc func rotateImageView(_ sender: UIRotationGestureRecognizer) {
        userChosenImage.transform = userChosenImage.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    // MARK: set the zooming functionality
    @objc func scaleImageView(_ sender: UIPinchGestureRecognizer) {
        userChosenImage.transform = userChosenImage.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
    
    // MARK: Function to make Buttons rounded
    @objc func rounded(button: UIButton) {
        var roundedButton = RoundedButton()
        roundedButton.setButton(button)
        roundedButton.rounded()
    }
    
}
    
    
    
    

