//
//  GameOverShare.swift
//  Gridy
//
//  Created by Peter Bradtke on 30/10/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit

extension GameOverController {
    //MARK: Sharing options
    func displaySharingOptions() {
        //prepare content to share
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.effect = nil
            self.optionsButton.alpha = 0
            self.scoreListView.alpha = 1
        }
        let note = "I MADE IT!"
        let image = composeCreationImage()
        let items = [image as Any, note as Any]
        //create activity view controller
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        //adapt for iPad
        activityViewController.popoverPresentationController?.sourceView = view
        //present activity view controller
        present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: Prepare image for share.
    func composeCreationImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let viewToShare = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        optionsButton.alpha = 1
        return viewToShare
    }
}

