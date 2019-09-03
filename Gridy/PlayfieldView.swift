//
//  PlayfieldView.swift
//  Gridy
//
//  Created by Peter Bradtke on 29/08/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class PlayfieldView: UIViewController, AVAudioPlayerDelegate {
    
    //Outlets
    @IBOutlet weak var CVOne: UICollectionView!
    @IBOutlet weak var CVTwo: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var popUpView: UIImageView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBAction func switchButtonOn(_ sender: UISwitch) {
    }
    
    
}
