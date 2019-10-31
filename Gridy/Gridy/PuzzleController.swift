//
//  PuzzleController.swift
//  Gridy
//
//  Created by Peter Bradtke on 29/09/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit
import Photos
//import MobileCoreServices
import AVFoundation
//import AudioToolbox

class PuzzleController: UIViewController, AVAudioPlayerDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tileView: UICollectionView!
    @IBOutlet weak var puzzleBoard: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var popUpView: UIImageView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBAction func switchButtonOn(_ sender: UISwitch) {
    }
    
    //MARK: - Variables
    var toReceive = [UIImage]()
    var tileViewImages :[UIImage]!
    var puzzleBoardImages = [UIImage]()
    var fixedImages = [UIImage(named: "Blank"), UIImage(named: "Gridy-lookup")]
    var moves: Int = 0
    var rightMoves: Int = 0
    var popUpImage = UIImage()
    var isSelected: IndexPath?
    var audioPlayer: AVAudioPlayer?
    
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tileViewImages = toReceive
        tileViewImages.shuffle()
        tileView.reloadData()
        popUpView.image = popUpImage
        popUpView.isHidden = true
        scoring(moves: moves)
        for image in fixedImages {
            if let image = image {
                tileViewImages.append(image)
            }
        }
        tileView.dragInteractionEnabled = true
        puzzleBoard.dragInteractionEnabled = true
        if puzzleBoardImages.count == 0 {
            if let blank = UIImage(named: "Blank") {
                var temp = [UIImage]()
                for _ in toReceive {
                    temp.append(blank)
                }
                puzzleBoardImages = temp
                puzzleBoard.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBActions
    @IBAction func newGameAction(_ sender: Any) { }
    
    func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "my3rdSegue" {
            let vc3 = segue.destination as! GameOverController
            vc3.popUpImage = popUpImage
            vc3.rightMoves = rightMoves
            vc3.moves = moves - 1
            vc3.score = yourScore()
        }
    }
    
    
}
